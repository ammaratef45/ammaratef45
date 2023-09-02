import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { CfnEIP, InstanceClass, InstanceSize, InstanceType, Vpc } from 'aws-cdk-lib/aws-ec2';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import * as path from 'path';
import { BehaviorOptions, CachePolicy, ICachePolicy, OriginRequestPolicy } from 'aws-cdk-lib/aws-cloudfront';
import { HttpOrigin } from 'aws-cdk-lib/aws-cloudfront-origins';
import { Bucket, BucketAccessControl, ObjectOwnership } from 'aws-cdk-lib/aws-s3';
import { AutoScalingGroup, IAutoScalingGroup, LifecycleHook, LifecycleTransition } from 'aws-cdk-lib/aws-autoscaling';
import { Function } from "aws-cdk-lib/aws-lambda";
import { LambdaFunction } from 'aws-cdk-lib/aws-events-targets';
import { PolicyStatement } from 'aws-cdk-lib/aws-iam';

const LOG_DAYS_TO_DELETE=3;

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

    // ====== existing components ====== //
    const asg = AutoScalingGroup.fromAutoScalingGroupName(this, 'asg', 'WordpressBlog-WebServerGroup-1ZQ6RC70U4DA') as AutoScalingGroup;

    // ========= lambda =============== //
    // lambda to recycle instances once a month
    const recycle_lambda = this.createRecycleLambda(this);
    // lambda to attach eip to new instances
    const attach_eip_lambda = this.createAttachEipLambda(this, asg, new CfnEIP(this, "eip", {}));

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
      resources: [
        media_access_key_secret.secretArn,
        'arn:aws:secretsmanager:us-east-1:835451110523:secret:cdn-public-crt-RgCjSM',
        'arn:aws:secretsmanager:us-east-1:835451110523:secret:cdn-private-key-yha9Gn',
        'arn:aws:secretsmanager:us-east-1:835451110523:secret:cdn-chain-lJ8Ok5'
      ],
    });
    const getSecretPolicy = new cdk.aws_iam.Policy(this, 'getSecretPolicy', {
      statements: [getSecretPolicyStatement]
    });
    const webServerRoleCfn = cfnInclude.getResource('WebServerRole') as cdk.aws_iam.CfnRole;
    const webServerRole = cdk.aws_iam.Role.fromRoleArn(this, 'WebServerRole', webServerRoleCfn.attrArn);
    webServerRole.attachInlinePolicy(getSecretPolicy);

    // create CDN
    const origin = this.createOrigin();
    const cacheEnabledBehavior = this.createBehavior(CachePolicy.CACHING_OPTIMIZED, origin);
    const cacheDisabledBehavior = this.createBehavior(CachePolicy.CACHING_DISABLED, origin);
    const logBucket = this.createLogBucket(this);
    const distribution = new cdk.aws_cloudfront.Distribution(this, 'cdn', {
      enableLogging: true,
      logBucket: logBucket,
      defaultBehavior: cacheEnabledBehavior,
      additionalBehaviors: [
        '/wp-login.php', '/wp-admin/*', '/wp-json/*', '/.well-known/*',
        '/wp-cron.php', '/xmlrpc.php', '/wp-trackback.php', '/wp-signup.php'
      ].reduce((acc, k)=>({...acc, [k]:cacheDisabledBehavior}), {}),
      minimumProtocolVersion: cdk.aws_cloudfront.SecurityPolicyProtocol.TLS_V1,
      domainNames: [
        'www.ammaratef45.com',
        '*.ammaratef45.com',
        'ammaratef45.com'
      ],
      certificate: cdk.aws_certificatemanager.Certificate.fromCertificateArn(this, 'cdnCert', 'arn:aws:acm:us-east-1:835451110523:certificate/58407219-e782-4e4a-8e0c-6596988aa455')
    });

    // Outputs
    new cdk.CfnOutput(this, 'cdn dns', {
      description: 'CDN Domain Name',
      value: distribution.domainName
    });
  }

  createLogBucket(scope: Construct): Bucket {
    return new Bucket(this, 'cdn_logbucket', {
      accessControl: BucketAccessControl.BUCKET_OWNER_READ,
      objectOwnership: ObjectOwnership.OBJECT_WRITER,
      lifecycleRules: [
        {
          expiration: cdk.Duration.days(LOG_DAYS_TO_DELETE),
        }
      ]
    });
  }

  createOrigin(): HttpOrigin {
    return new cdk.aws_cloudfront_origins.HttpOrigin('cdn.ammaratef45.com', {
      keepaliveTimeout: cdk.Duration.seconds(60),
      readTimeout: cdk.Duration.seconds(30),
    });
  }

  createBehavior(cachePolicy: ICachePolicy, origin: HttpOrigin): BehaviorOptions {
    return {
      origin: origin,
      originRequestPolicy: OriginRequestPolicy.ALL_VIEWER_EXCEPT_HOST_HEADER,
      cachePolicy: cachePolicy,
      viewerProtocolPolicy: cdk.aws_cloudfront.ViewerProtocolPolicy.REDIRECT_TO_HTTPS,
      allowedMethods: cdk.aws_cloudfront.AllowedMethods.ALLOW_ALL,
      cachedMethods: cdk.aws_cloudfront.CachedMethods.CACHE_GET_HEAD_OPTIONS,
    };
  }

  createRecycleLambda(scope: Construct): Function {
    const lambda = this.createLambda(scope, 'refereshInstancesFunction', 'refereshInstancesHandler');
    const scaleUpPolicy = this.createScaleUpPolicy();
    lambda.role?.attachInlinePolicy(
      new cdk.aws_iam.Policy(this, 'scale-up-policy', {
        statements: [scaleUpPolicy],
      }),
    );
    const rule = this.createSceduleRule(this);
    rule.addTarget(new LambdaFunction(lambda));
    return lambda;
  }

  createScaleUpPolicy(): PolicyStatement {
    return new PolicyStatement({
      actions: ['autoscaling:SetDesiredCapacity'],
      resources: ['*'],
    });
  }

  createSceduleRule(scope: Construct): cdk.aws_events.Rule {
    return new cdk.aws_events.Rule(scope, 'Schedule Rule', {
      schedule: cdk.aws_events.Schedule.expression('rate(7 days)'),
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

  createAttachEipLambda(scope: Construct, asg: IAutoScalingGroup, eip: CfnEIP) {
    const lambda = this.createLambda(scope, 'attachEipLambda', 'attachEipHandler');
    const hook = new LifecycleHook(this, "attachEipHook", {
      autoScalingGroup: asg,
      lifecycleTransition: LifecycleTransition.INSTANCE_LAUNCHING,
      notificationTarget: new cdk.aws_autoscaling_hooktargets.FunctionHook(lambda),
      heartbeatTimeout: cdk.Duration.seconds(300),
    });
    const policy = this.createEipLambdaPolicy();
    lambda.role?.attachInlinePolicy(
      new cdk.aws_iam.Policy(this, 'attach-eip-policy', {
        statements: [policy],
      }),
    );
  }

  createEipLambdaPolicy(): PolicyStatement {
    return new PolicyStatement({
      actions: [
        'autoscaling:CompleteLifecycleAction',
        'ec2:AssociateAddress'
      ],
      resources: ['*'],
    });
  }

  createLambda(scope: Construct, id: string, dir: string): Function {
    return new Function(scope, id, {
      runtime: Runtime.PYTHON_3_8,
      code: cdk.aws_lambda.Code.fromAsset(path.join(__dirname, dir)),
      handler: 'index.main',
    });
  }
}
