import boto3

AUTO_SCALING_GROUP_NAME = 'WordpressBlog-WebServerGroup-1ZQ6RC70U4DA'
KEY_NAME = 'wordpressKey'
STACK_NAME = 'WordpressBlog'

autoscaling = boto3.client('autoscaling')
ec2 = boto3.client('ec2')
cloudformation = boto3.client('cloudformation')


def instances():
  return ec2.describe_instances(
    Filters=[
      {
        'Name': 'key-name',
        'Values': [
          KEY_NAME
        ]
      },
      {
        'Name': 'instance-state-name',
        'Values': [
          'running'
        ]
      }
    ]
  )

def print_instance_ids():
  for reservation in instances()['Reservations']:
    for instance in reservation['Instances']:
      print(instance['InstanceId'])

def change_desired_capacity(new_capacity):
  autoscaling.set_desired_capacity(
    AutoScalingGroupName=AUTO_SCALING_GROUP_NAME,
    DesiredCapacity=new_capacity,
  )

def change_capacity_to_2():
  change_desired_capacity(2)

def print_ssh_command():
  for reservation in instances()['Reservations']:
    for instance in reservation['Instances']:
      print('ssh -i {}.pem ec2-user@{}'.format(KEY_NAME, instance['PublicDnsName']))

def get_cfn_stack_status():
  stack = cloudformation.describe_stacks(
    StackName = STACK_NAME
  )
  stack = stack['Stacks'][0]
  status = stack['StackStatus']
  time = stack['LastUpdatedTime']
  print('Status:{}, time:{}'.format(status, time))

class Command:
  def __init__(self, name, action):
      self.name = name
      self.action = action


commands = {
  '0': Command('Change desired capacity to 2', change_capacity_to_2),
  '1': Command('print ssh command for running hosts', print_ssh_command),
  '2': Command('print cfn status', get_cfn_stack_status),
  '3': Command('print instance Ids', print_instance_ids)
}

if __name__=='__main__':
  for index in commands.keys():
    print('{}: {}'.format(index, commands.get(index).name))
  choice = input('Type the key of desired action: ')
  commands.get(choice).action()