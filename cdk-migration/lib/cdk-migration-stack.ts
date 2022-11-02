import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Instance, InstanceClass, InstanceSize, InstanceType, Vpc } from 'aws-cdk-lib/aws-ec2';
import { Runtime } from 'aws-cdk-lib/aws-lambda';
import * as path from 'path';

export class CdkMigrationStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const vpc = Vpc.fromLookup(this, 'default-vpc', {
      vpcId: 'vpc-098d5d6d1fc720f01'
    });

    const instanceType = InstanceType.of(InstanceClass.T2, InstanceSize.MICRO);

    const cfnInclude = new cdk.cloudformation_include.CfnInclude(this, 'Template', { 
      templateFile: 'migration-template.json',
      parameters: {
          'InstanceType': instanceType.toString()
        },
    });
    cfnInclude.getNestedStack
    let asg = cfnInclude.getResource('WebServerGroup') as cdk.aws_autoscaling.CfnAutoScalingGroup;
    const lambda = new cdk.aws_lambda.Function(this, 'refereshInstancesFunction', {
      runtime: Runtime.PYTHON_3_8,
      code: cdk.aws_lambda.Code.fromAsset(path.join(__dirname, 'refereshInstancesHandler')),
      handler: 'index.main',
    });
    const scaleUpPolicy = new cdk.aws_iam.PolicyStatement({
      actions: ['autoscaling:SetDesiredCapacity'],
      resources: ['*'],
    });
    lambda.role?.attachInlinePolicy(
      new cdk.aws_iam.Policy(this, 'scale-up-policy', {
        statements: [scaleUpPolicy],
      }),
    );
    const rule = new cdk.aws_events.Rule(this, 'Schedule Rule', {
      schedule: cdk.aws_events.Schedule.expression('rate(30 days)'),
     });
     rule.addTarget()
     rule.addTarget(new cdk.aws_events_targets.LambdaFunction(lambda));
  }
}
