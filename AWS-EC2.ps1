# === Remove old version of AWS SSM module (if installed) ===
Uninstall-Module -Name AWS.Tools.SimpleSystemsManagement -AllVersions -Force

# === Install the latest version of AWS SSM PowerShell module ===
Install-Module -Name AWS.Tools.SimpleSystemsManagement -Force

# === Import the AWS SSM module into your session ===
Import-Module AWS.Tools.SimpleSystemsManagement

# === Get the latest Windows AMI ID using AWS SSM Parameter ===
Get-SSMLatestEC2Image -Path ami-windows-latest | Format-List

# === Create a new security group for RDP access ===
aws ec2 create-security-group `
  --group-name "RDP-SG" `
  --description "Security group for RDP access" `
  --region "us-east-1"

# === Allow RDP access (port 3389) from any IP (be cautious!) ===
aws ec2 authorize-security-group-ingress `
  --group-id sg-034063e79811d8efd `
  --protocol tcp `
  --port 3389 `
  --cidr 0.0.0.0/0 `
  --region "us-east-1"

# === Create an EC2 key pair and save the private key locally ===
aws ec2 create-key-pair `
  --key-name Azi-Third `
  --region us-east-1 `
  --query 'KeyMaterial' `
  --output text > Azi-Third.pem

# === Launch a Windows EC2 instance with RDP enabled via user-data ===
aws ec2 run-instances `
  --image-id ami-0a72780db6b062c23 `
  --count 1 `
  --instance-type t2.micro `
  --key-name Azi-Third `
  --security-group-ids sg-034063e79811d8efd `
  --region us-east-1 `
  --placement AvailabilityZone=us-east-1a `
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Azi-Third}]' `
  --user-data "<powershell>
  Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
  Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
</powershell>"

# === Display Instance ID and Public IP in a readable table ===
aws ec2 describe-instances `
  --region us-east-1 `
  --query "Reservations[].Instances[].[InstanceId,PublicIpAddress]" `
  --output table

# === View the contents of the PEM file (private key) ===
Get-Content -Path .\Azi-Third.pem

#THen you get your Private Key and Password on the AWS console,
#then you can login RemoteDesktopProtocol (rdp) as Administrator and enter the password generated on your AWS console,
#then you can download Apache on your beowser and configure it for use. Thank You
