import boto3

AUTO_SCALING_GROUP_NAME = 'WordpressBlog-WebServerGroup-1ZQ6RC70U4DA'
autoscaling = boto3.client('autoscaling')

def main(event, context):
  response = autoscaling.set_desired_capacity(
    AutoScalingGroupName=AUTO_SCALING_GROUP_NAME,
    DesiredCapacity=2,
    HonorCooldown=True
  )
  print(response)