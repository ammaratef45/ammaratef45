import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { Instance, InstanceClass, InstanceSize, InstanceType, Vpc } from 'aws-cdk-lib/aws-ec2';

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
  }
}
