#Gets the Modules and versions of aws you have installed
Get-Module aws* -ListAvailable

Set-AWSCredential -AccessKey "" -SecretKey "" -StoreAs default

aws ec2 create-security-group --group-name "SG-RDP" --description "RDP-SG" --region "us-east-1"

aws ec2 authorize-security-group-ingress --group-id sg-xxxxxxx --protocol tcp --port 3389 --cidr 0.0.0.0 --region "us-east-1"

aws ec2 create-key-pair --keyn-name Azi --region us-east-1 --query 'KeyMaterial' --output text > Azi.pem ; 
aws ec2 run-instances --image id ami-xxxxxxxxxxxxxx --count 1 --instance-type t2.micro --key-name Azi 
--security-group-ids sg-xxxxxxxx --region us-east-1 --placement AvailabilityZone=us-east-1a --tag-specifications 'ResourceType-Instance,Tags=[{KeyName,Value=Azi}]'
--user-data "<powershell>
Set-ItemPropert -Path '' -Name '' -value 0
Enable-NetFirewallRule -DisplayGroup 'RemoteDesktop' </powershell>"

Get-Content -path .\Azi.pem

#Set up Apache to run on the 

#checking if i have aws
aws configure;

#choose an ami id image
aws ec2 describe-images \
    --owners 099720109477 \
    --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*' \
    --query 'Images[*].[ImageId,Name]' \
    --output table


    #launch the ec2 instance
    aws ec2 run-instances \
  --image-id ami-0c02fb55956c7d316 \
  --instance-type t2.micro \
  --key-name MyKeyPair \
  --security-groups default \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyUbuntuServer}]'

  #verify the instance
  aws ec2 describe-instances \
  --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress,Tags]' \
  --output table

#terminate to avoid charges
aws ec2 terminate-instances --instance-ids i-xxxxxxxxxxxxxxxxx




ami-0fc5d935ebf8bc3bc

aws ec2 run-instances `
     --image-id ami-0fc5d935ebf8bc3bc `
     --count 1 `
     --instance-type t2.micro `
     --key-name myPSKeyPair `
      --security-group-ids sg-xxxxxxxx `
       --subnet-id subnet-xxxxxxxx `
       --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyAWSCLIDemoInstance}]'







       $ImageId = "ami-0abcdef1234567890"        # Replace with a valid AMI ID
       $InstanceType = "t2.micro"                # Free-tier eligible instance
       $KeyName = "AziKeyPair"                    # Replace with your key pair name
      # $SecurityGroupId = "sg-0123456789abcdef0" # Replace with your security group ID
       $SubnetId = "subnet-0123456789abcdef0"    # Replace with your subnet ID
       $TagName = "AziDemoEC2Instance"            # Name your instance
       $Region = "us-east-1"                     # Choose your region
       
       # Launch the EC2 instance
       aws ec2 run-instances `
           --image-id $ImageId `
           --count 1 `
           --instance-type $InstanceType `
           --key-name $KeyName `
           --security-group-ids $SecurityGroupId `
           --subnet-id $SubnetId `
           --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TagName}]" `
           --region $Region `
           --output table
       





           $ImageId = "ami-051f7e7f6c2f40dc1"        # Real Amazon Linux 2 AMI ID in us-east-1
           $InstanceType = "t2.micro"               # Free-tier eligible
           $KeyName = "AziKeyPair"                  # Your existing key pair name
          # $SecurityGroupId = "sg-xxxxxxxxxxxxxxxxx" # Replace with your actual SG ID
           $SubnetId = "subnet-0f17230b40d6adf03"   # Replace with actual subnet
           $TagName = "AziDemoEC2Instance"
           $Region = "us-east-1"
           
           aws ec2 run-instances `
               --image-id $ImageId `
               --count 1 `
               --instance-type $InstanceType `
               --key-name $KeyName `
               --security-group-ids $SecurityGroupId `
               --subnet-id $SubnetId `
               --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TagName}]" `
               --region $Region `
               --output table
           


















               PS C:\Windows\system32> Install-Module -Name AWS.Tools.EC2 -Force -Scope AllUsers
>>
PS C:\Windows\system32> Get-Command New-EC2Vpc
>>

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          New-EC2Vpc                                         4.1.793    AWS.Tools.EC2


PS C:\Windows\system32> #^C
PS C:\Windows\system32> $vpcCidr = "10.0.0.0/16"
>> $vpc = New-EC2Vpc -CidrBlock $vpcCidr
>>
PS C:\Windows\system32> Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsSupport $true
PS C:\Windows\system32> Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsHostnames $true
PS C:\Windows\system32> $internetGateway = New-EC2InternetGateway
PS C:\Windows\system32> Add-EC2InternetGateway -InternetGatewayId $internetGateway.InternetGatewayId -VpcId $vpc.VpcId
PS C:\Windows\system32> $routeTable = New-EC2RouteTable -VpcId $vpc.VpcId
PS C:\Windows\system32> New-EC2Route -GatewayId $internetGateway.InternetGatewayId -RouteTableId $routeTable.RouteTableId -DestinationCidrBlock '0.0.0.0/0'
True
PS C:\Windows\system32> Get-EC2AvailabilityZone -Region us-east-1 | ft RegionName,State,ZoneName

RegionName State     ZoneName
---------- -----     --------
us-east-1  available us-east-1a
us-east-1  available us-east-1b
us-east-1  available us-east-1c
us-east-1  available us-east-1d
us-east-1  available us-east-1e
us-east-1  available us-east-1f


PS C:\Windows\system32> $subnet = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '10.0.1.0/24'  AvailabilityZone 'us-east-1a'
New-EC2Subnet : A positional parameter cannot be found that accepts argument 'us-east-1a'.
At line:1 char:11
+ $subnet = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '10.0.1.0/24'  A ...
+           ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [New-EC2Subnet], ParameterBindingException
    + FullyQualifiedErrorId : PositionalParameterNotFound,Amazon.PowerShell.Cmdlets.EC2.NewEC2SubnetCmdlet

PS C:\Windows\system32> $subnet = New-EC2Subnet -VpcId $vpc.VpcId -CidrBlock '10.0.1.0/24' -AvailabilityZone 'us-east-1a'
>>
Register-EC2RouteTable -RouteTableId $routeTable.RouteTableId -SubnetId $subnet.SubnetId
rtbassoc-00d0245695dc89a71
$subnet.SubnetId
subnet-0f17230b40d6adf03

$ImageId = "ami-051f7e7f6c2f40dc1"        # Real Amazon Linux 2 AMI ID in us-east-1
$ImageID = " ami-049dd04cca2dc5594"       # Windows_Server-2019-English-Full-Base-2025.01.15
>>            $InstanceType = "t2.micro"               # Free-tier eligible
>>            $KeyName = "AziKeyPair"                  # Your existing key pair name
>>           # $SecurityGroupId = "sg-xxxxxxxxxxxxxxxxx" # Replace with your actual SG ID
>>         #   $SubnetId = "subnet-0f17230b40d6adf03"   # Replace with actual subnet
>>            $TagName = "AziDemoEC2Instance"
>>            $Region = "us-east-1"
>>
>>            aws ec2 run-instances `
>>                --image-id $ImageId `
>>                --count 1 `
>>                --instance-type $InstanceType `
>>                --key-name $KeyName `
>>                --security-group-ids $SecurityGroupId `
>>                --subnet-id $SubnetId `
>>                --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TagName}]" `
>>                --region $Region `
>>                --output table
>>

An error occurred (InvalidKeyPair.NotFound) when calling the RunInstances operation: The key pair 'AziKeyPair' does not exist
PS C:\Windows\system32> aws ec2 create-key-pair --key-name AziKeyPair --query "KeyMaterial" --output text > AziKeyPair.pem
>>
PS C:\Windows\system32> $KeyName = "AziKeyPair"  # Use the key pair you just created
>>
PS C:\Windows\system32> aws ec2 run-instances `
>>                --image-id $ImageId `
>>                --count 1 `
>>                --instance-type $InstanceType `
>>                --key-name $KeyName `
>>                --security-group-ids $SecurityGroupId `
>>                --subnet-id $SubnetId `
>>                --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TagName}]" `
>>                --region $Region `
>>                --output table


PS C:\Windows\system32> aws ec2 allocate-address --domain vpc --output json
>>
{
    "AllocationId": "eipalloc-0160427936e31b866",
    "PublicIpv4Pool": "amazon",
    "NetworkBorderGroup": "us-east-1",
    "Domain": "vpc",
    "PublicIp": "13.219.121.48"
}

#INSTANCE ID = i-0373e0ad66c444831
#|                     DescribeAddresses                     |
+-----------------------------------------------------------+
||                        Addresses                        ||
|+--------------------------+------------------------------+|
||  AllocationId            |  eipalloc-0160427936e31b866  ||
||  AssociationId           |  eipassoc-00d37f644864dae3f  ||
||  Domain                  |  vpc                         ||
||  InstanceId              |  i-0048a5aad951595e6         ||
||  NetworkBorderGroup      |  us-east-1                   ||
||  NetworkInterfaceId      |  eni-0c5bbc088c88c1b86       ||
||  NetworkInterfaceOwnerId |  593793068113                ||
||  PrivateIpAddress        |  172.31.22.74                ||
||  PublicIp                |  13.219.121.48               ||
||  PublicIpv4Pool          |  amazon                      ||
|+--------------------------+--------------





















#Update the Image ID for Windows Server
aws ec2 describe-images --owners amazon --filters "Name=name,Values=Windows_Server-2019-English-Full-Base*" --query "Images[*].[ImageId,Name]" --output table


