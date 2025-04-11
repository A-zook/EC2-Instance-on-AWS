#Destiny's Method

Uninstall-Module -Name AWS.Tools.SimpleSystemsManagement -AllVersions -Force
Install-Module -Name AWS.Tools.SimpleSystemsManagement -Force
Import-Module AWS.Tools.SimpleSystemsManagement

Get-SSMLatestEC2Image -Path ami-windows-latest |Format-List

#Create security groups for EC2
aws ec2 create-security-group --group-name "RDP-SG" --description "Security group for RDP access" --region "us-east-1"

#Authorise the RDP security port
aws ec2 authorize-security-group-ingress --group-id sg-034063e79811d8efd --protocol tcp --port 3389 --cidr 0.0.0.0/0 --region "us-east-1"

#Create keypairs 
aws ec2 create-key-pair --key-name Azi-First --region us-east-1 --query 'KeyMaterial' --output text > Azi-First.pem ;

#Create instance
aws ec2 run-instances --image-id ami-0a72780db6b062c23 --count 1 --instance-type t2.micro --key-name Azi-First --security-group-ids sg-034063e79811d8efd --region us-east-1 --placement AvailabilityZone=us-east-1a --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Azi-First}]' --user-data "<powershell>
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
</powershell>"

aws ec2 describe-instances --region us-east-1 --query "Reservations[].Instances[].[InstanceId,PublicIpAddress]" --output table

Get-Content -Path .\Azi-First.pem


















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




















<#
.SYNOPSIS
    Deploys a Windows EC2 instance with RDP access enabled.
.DESCRIPTION
    This script:
    1. Sets up AWS SSM tools.
    2. Creates a security group for RDP.
    3. Generates a key pair for authentication.
    4. Launches a Windows instance with auto-configured RDP.
.NOTES
    Author: Your Name
    Date:   $(Get-Date -Format "yyyy-MM-dd")
#>

# --- Step 1: Ensure AWS SSM Tools are Installed ---
# Uninstall, reinstall, and import the AWS SSM module for reliability.
Uninstall-Module -Name AWS.Tools.SimpleSystemsManagement -AllVersions -Force -ErrorAction SilentlyContinue
Install-Module -Name AWS.Tools.SimpleSystemsManagement -Force -AllowClobber
Import-Module AWS.Tools.SimpleSystemsManagement

# --- Step 2: Fetch the Latest Windows AMI ---
Write-Host "Fetching the latest Windows AMI..."
$latestWindowsAMI = Get-SSMLatestEC2Image -Path ami-windows-latest
$latestWindowsAMI | Format-List

# --- Step 3: Create Security Group for RDP ---
Write-Host "Creating security group..."
$securityGroup = aws ec2 create-security-group `
    --group-name "RDP-SG" `
    --description "Security group for RDP access" `
    --region "us-east-1" `
    --output json | ConvertFrom-Json

# --- Step 4: Allow RDP Traffic (Replace 0.0.0.0/0 with your IP!) ---
Write-Host "Configuring RDP access..."
aws ec2 authorize-security-group-ingress `
    --group-id $securityGroup.GroupId `
    --protocol tcp `
    --port 3389 `
    --cidr "$(Invoke-RestMethod -Uri 'https://api.ipify.org?format=json').ip/32" `
    --region "us-east-1"

# --- Step 5: Create Key Pair ---
Write-Host "Generating key pair..."
aws ec2 create-key-pair `
    --key-name "Azi-Fourth" `
    --region "us-east-1" `
    --query 'KeyMaterial' `
    --output text > "Azi-Fourth.pem"

# Set secure permissions for the .pem file
icacls "Azi-Fourth.pem" /inheritance:r /grant:r "$env:USERNAME:(F)"

# --- Step 6: Launch EC2 Instance ---
Write-Host "Launching Windows instance..."
aws ec2 run-instances `
    --image-id $latestWindowsAMI.ImageId `
    --count 1 `
    --instance-type "t2.micro" `
    --key-name "Azi-Fourth" `
    --security-group-ids $securityGroup.GroupId `
    --region "us-east-1" `
    --placement "AvailabilityZone=us-east-1a" `
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=Azi-Fourth}]' `
    --user-data "<powershell>
        Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name 'fDenyTSConnections' -Value 0
        Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'
    </powershell>"

# --- Step 7: Verify Instance Status ---
Write-Host "Checking instance status..."
aws ec2 describe-instances `
    --region "us-east-1" `
    --filters "Name=tag:Name,Values=Azi-Fourth" `
    --query "Reservations[].Instances[].[InstanceId, PublicIpAddress, State.Name]" `
    --output table

# --- Step 8: Display Private Key (For Reference) ---
Write-Host "Private key saved to: $((Get-Item .\Azi-Fourth.pem).FullName)"
Get-Content -Path .\Azi-Fourth.pem  # Uncomment only if needed