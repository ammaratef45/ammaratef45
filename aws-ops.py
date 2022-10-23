import boto3
from blessings import Terminal
import keyboard

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
  ids = []
  for reservation in instances()['Reservations']:
    for instance in reservation['Instances']:
      ids.append(instance['InstanceId'])
  return ids

def terminate_instance(instance_id):
  ec2.terminate_instances(
    InstanceIds=[instance_id]
  )
  return 'Terminated {}'.format(instance_id)

def terminate_instance_prompt():
  instanceId = input('Enter instance ID:')
  terminate_instance(instanceId)

def change_desired_capacity(new_capacity):
  autoscaling.set_desired_capacity(
    AutoScalingGroupName=AUTO_SCALING_GROUP_NAME,
    DesiredCapacity=new_capacity,
  )

def referesh_instances():
  return autoscaling.start_instance_refresh(
    AutoScalingGroupName=AUTO_SCALING_GROUP_NAME
  )

def print_ssh_command():
  results = []
  for reservation in instances()['Reservations']:
    for instance in reservation['Instances']:
      results.append('ssh -i {}.pem ec2-user@{}'.format(KEY_NAME, instance['PublicDnsName']))
  return results

def get_cfn_stack_status():
  stack = cloudformation.describe_stacks(
    StackName = STACK_NAME
  )
  stack = stack['Stacks'][0]
  status = stack['StackStatus']
  time = stack['LastUpdatedTime']
  return 'Status:{}, time:{}'.format(status, time)

class Command:
  def __init__(self, name, action):
      self.name = name
      self.action = action


commands = {
  0: Command('refresh instances', referesh_instances),
  1: Command('print ssh command for running hosts', print_ssh_command),
  2: Command('print cfn status', get_cfn_stack_status),
  3: Command('print instance Ids', print_instance_ids),
  4: Command('Terminate an EC2 Instance', terminate_instance_prompt)
}

selected = 0
output_default = 'press space after selecting'
output = output_default[:]

def terminal():
  global selected
  global output
  term = Terminal()
  print(term.clear())
  for index in commands.keys():
    pre = '[x]' if index == selected else '[ ]'
    print('{} {}'.format(pre, commands.get(index).name))
  with term.location(0, term.height - 1):
    print(output)

def down(e):
  global selected
  global output
  output = output_default[:]
  selected = min(selected+1, len(commands)-1)
  terminal()

def up(e):
  global selected
  global output
  output = output_default[:]
  selected = max(selected-1, 0)
  terminal()

def space(e):
  global selected
  global output
  output = commands.get(selected).action()
  terminal()

if __name__=='__main__':
  terminal()
  keyboard.on_press_key("down arrow", down)
  keyboard.on_press_key("up arrow", up)
  keyboard.on_press_key("space", space)
  while True:
    continue