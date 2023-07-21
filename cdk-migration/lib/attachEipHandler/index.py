import boto3
import json

AUTO_SCALING_GROUP_NAME = 'WordpressBlog-WebServerGroup-1ZQ6RC70U4DA'
autoscaling = boto3.client('autoscaling')
ec2 = boto3.client('ec2')
allocationId = 'eipalloc-0784cb27474081aed'

def main(event, context):
  """
  SNS object structure:
    {'Type': '', 'MessageId': '', 'TopicArn': '', 'Subject': "", 'Message': '{}', 'Timestamp': ''}
  Message structure:
    {"Origin":"","LifecycleHookName":"","Destination":"","AccountId":"","RequestId":"",
    "LifecycleTransition":"","AutoScalingGroupName":"","Service":"","Time":"","EC2InstanceId":"",
    "LifecycleActionToken":""}
  LifecycleTransition: autoscaling:EC2_INSTANCE_LAUNCHING
  """
  sns_object = event['Records'][0]['Sns']
  message = json.loads(sns_object['Message'])
  instance_id = message['EC2InstanceId']
  response = ec2.associate_address(AllocationId=allocationId, InstanceId=instance_id)
  print(response)
  response = autoscaling.complete_lifecycle_action(
    LifecycleHookName=message['LifecycleHookName'],
    AutoScalingGroupName=message['AutoScalingGroupName'],
    LifecycleActionToken=message['LifecycleActionToken'],
    LifecycleActionResult='CONTINUE', # CONTINUE or ABANDON
    InstanceId=instance_id
  )
  print(response)

