import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { InstanceClass, InstanceSize, InstanceType, Vpc } from 'aws-cdk-lib/aws-ec2';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import * as path from 'path';

export class CdkMigrationStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    // vpc just in case (I don't want to look it up when I need it)
    const vpc = Vpc.fromLookup(this, 'default-vpc', {
      vpcId: 'vpc-098d5d6d1fc720f01'
    });

    // Pass instancetype to the cloudformation template parameter
    const instanceType = InstanceType.of(InstanceClass.T2, InstanceSize.MICRO);
    const cfnInclude = new cdk.cloudformation_include.CfnInclude(this, 'Template', { 
      templateFile: 'migration-template.json',
      parameters: {
          'InstanceType': instanceType.toString()
        },
    });

    // lambda to recycle instances once a month
    const lambda = this.createRecycleLambda(this);
    const scaleUpPolicy = this.createScaleUpPolicy();
    lambda.role?.attachInlinePolicy(
      new cdk.aws_iam.Policy(this, 'scale-up-policy', {
        statements: [scaleUpPolicy],
      }),
    );
    const rule = this.createSceduleRule(this);
    rule.addTarget(new cdk.aws_events_targets.LambdaFunction(lambda));

    // create s3 bucket for the wp media
    const media_bucket = new cdk.aws_s3.Bucket(this, 'media-bucket', {});
    const media_policy = this.createMediaPolicy(this, media_bucket);

    // create a user that can access the media bucket
    const media_user = new cdk.aws_iam.User(this, 'media-user', {
      managedPolicies: [media_policy]
    });
    const media_access_key = new cdk.aws_iam.AccessKey(this, 'media-accesskey', {user: media_user});

    // keep access key in secrets manager for security
    const media_access_key_secret = new cdk.aws_secretsmanager.Secret(this, 'media-accesskey-secret', {
      secretName: 'media-access-keyid',
      secretObjectValue: {
        'keyId': new cdk.SecretValue(media_access_key.accessKeyId),
        'secretKey': media_access_key.secretAccessKey,
      }
    });

    // allow server instance to get the accesskey secret
    const getSecretPolicyStatement = new cdk.aws_iam.PolicyStatement({
      actions: ['secretsmanager:GetSecretValue'],
      resources: [media_access_key_secret.secretArn],
    });
    const getSecretPolicy = new cdk.aws_iam.Policy(this, 'getSecretPolicy', {
      statements: [getSecretPolicyStatement]
    });
    const webServerRoleCfn = cfnInclude.getResource('WebServerRole') as cdk.aws_iam.CfnRole;
    const webServerRole = cdk.aws_iam.Role.fromRoleArn(this, 'WebServerRole', webServerRoleCfn.attrArn);
    webServerRole.attachInlinePolicy(getSecretPolicy);

    // create CDN
    
    const loadBalancer_cfn = cfnInclude.getResource('ApplicationLoadBalancer') as cdk.aws_elasticloadbalancingv2.CfnLoadBalancer;
    const listner_cfn = cfnInclude.getResource('HTTPSListener') as cdk.aws_elasticloadbalancingv2.CfnListener;
    const listener = cdk.aws_elasticloadbalancingv2.ApplicationListener.fromApplicationListenerAttributes(this, 'listener', {
      listenerArn: listner_cfn.attrListenerArn,
      securityGroup: cdk.aws_ec2.SecurityGroup.fromSecurityGroupId(this,'listenerSG',loadBalancer_cfn.attrSecurityGroups[0]),
    });
    const certificate = cdk.aws_elasticloadbalancingv2.ListenerCertificate.fromArn('arn:aws:acm:us-east-1:835451110523:certificate/0fe091aa-a16d-4660-afb8-cd5ef7b56c83');
    listener.addCertificates('certs', [certificate]);
    const loadBalancer = cdk.aws_elasticloadbalancingv2.ApplicationLoadBalancer.fromApplicationLoadBalancerAttributes(this, 'lb', {
      loadBalancerArn: listner_cfn.loadBalancerArn,
      securityGroupId: loadBalancer_cfn.attrSecurityGroups[0],
      loadBalancerDnsName: loadBalancer_cfn.attrDnsName
    });
    const distribution = new cdk.aws_cloudfront.Distribution(this, 'cdn', {
      defaultBehavior: {
        origin: new cdk.aws_cloudfront_origins.HttpOrigin('cdn.ammaratef45.com', {
          keepaliveTimeout: cdk.Duration.seconds(60),
          readTimeout: cdk.Duration.seconds(30),
        }),
        viewerProtocolPolicy: cdk.aws_cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
        allowedMethods: cdk.aws_cloudfront.AllowedMethods.ALLOW_ALL,
        cachedMethods: cdk.aws_cloudfront.CachedMethods.CACHE_GET_HEAD_OPTIONS,
      },
      minimumProtocolVersion: cdk.aws_cloudfront.SecurityPolicyProtocol.TLS_V1,
    });
  }

  createRecycleLambda(scope: Construct): cdk.aws_lambda.Function {
    return new cdk.aws_lambda.Function(scope, 'refereshInstancesFunction', {
      runtime: Runtime.PYTHON_3_8,
      code: cdk.aws_lambda.Code.fromAsset(path.join(__dirname, 'refereshInstancesHandler')),
      handler: 'index.main',
    });
  }

  createScaleUpPolicy(): cdk.aws_iam.PolicyStatement {
    return new cdk.aws_iam.PolicyStatement({
      actions: ['autoscaling:SetDesiredCapacity'],
      resources: ['*'],
    });
  }

  createSceduleRule(scope: Construct): cdk.aws_events.Rule {
    return new cdk.aws_events.Rule(scope, 'Schedule Rule', {
      schedule: cdk.aws_events.Schedule.expression('rate(30 days)'),
     });
  }

  createMediaPolicy(scope: Construct, bucket: cdk.aws_s3.Bucket): cdk.aws_iam.ManagedPolicy {
    return new cdk.aws_iam.ManagedPolicy(this, 'media-policy', {
      statements: [
        new cdk.aws_iam.PolicyStatement({
          resources: [
            bucket.bucketArn,
            bucket.arnForObjects('*')
          ],
          actions: [
            's3:PutObject',
            's3:GetObjectAcl',
            's3:GetObject',
            's3:PutBucketAcl',
            's3:ListBucket',
            's3:DeleteObject',
            's3:GetBucketAcl',
            's3:GetBucketLocation',
            's3:PutObjectAcl'
          ]
        })
      ]
     });
  }
}
