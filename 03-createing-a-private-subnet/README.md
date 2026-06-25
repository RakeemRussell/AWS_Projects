# Creating a Private Subnet

## Project Overview

![Architecture Diagram](docs/image-1.png)

In this project, I will first recreate the previous resources from the first two networking projects with AWS CLI, including VPC, subnet, internet gateway, route table, security groups and network ACLs, one command at a time, showing the results in the AWS console and AWS CLI. From there I will continue to build a Private subnet, Private route table and Private network ACL in the AWS console.

## Technologies Used

### Cloud Services
- AWS VPC
- AWS Public and Private Subnets
- AWS IGW
- AWS Public and Private RTBs
- AWS SG
- AWS Public and Private NALCs

### Tools
- AWS CLI
- Git
- GitHub

### Skills Demonstrated
- Network Segmentation
- Cloud Infrastructure Management
- AWS Management Console

## Recreate and build on top of previous resources, What I did in this step
Repeating steps from the first two networking projects to set up VPC, subnet, internet gateway, route table, security group and network ACLs using AWS CLI.

Defined vpc, subnet, igw, route table and security group in git-bash. (I captured the network_acl in NACL_ID after AWS created it)

![Screenshots](screenshots/variables.png)

------------------------------
ran command:

VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --query 'Vpc.VpcId' \
    --output text \
    --region $REGION)
    
echo "VPC Created: $VPC_ID"

![Screenshots](screenshots/vpc-sc.png)

result: successful creation

![Screenshots](screenshots/aws-ec2-create-tags.png)

------------------------------
ran command:

aws ec2 create-tags \
    --resources $VPC_ID \
    --tags Key=Name,Value=$VPC_NAME \
    --region $REGION

![Screenshots](screenshots/aws-ec2-create-tags.png)

result: successful creation of vpc tags

![Screenshots](screenshots/vpc-tags.png)

------------------------------
ran command:

SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $SUBNET_CIDR \
    --query 'Subnet.SubnetId' \
    --output text \
    --region $REGION)

echo "Subnet Created: $SUBNET_ID"

![Screenshots](screenshots/aws-ec2-create-subnet.png)

result: successful creation of subnet

![Screenshots](screenshots/subnet-console.png)
------------------------------
ran command:

aws ec2 create-tags \
    --resources $SUBNET_ID \
    --tags Key=Name,Value=$SUBNET_NAME \
    --region $REGION

![Screenshots](screenshots/subnet-gitbash.png)

result: successful creation of subnet tags

![Screenshots](screenshots/subnet-tagged.png)
------------------------------
ran command:

IGW_ID=$(aws ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' \
    --output text \
    --region $REGION)

echo "IGW Created: $IGW_ID"

![Screenshots](screenshots/igw-gitbash.png)

result: successful creation of IGW

![Screenshots](screenshots/igw-detached-console.png)

------------------------------
ran command:

aws ec2 attach-internet-gateway \
    --internet-gateway-id $IGW_ID \
    --vpc-id $VPC_ID \
    --region $REGION

![Screenshots](screenshots/igw-attached-gitbash.png)

result: successfully attached IGW to the vpc

![Screenshots](screenshots/igw-attached-console.png)

------------------------------
ran command:

RT_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --query 'RouteTable.RouteTableId' \
    --output text \
    --region $REGION)

echo "Route Table Created: $RT_ID"

![Screenshots](screenshots/rtb-gitbash.png)

result: successful creation of rtb

![Screenshots](screenshots/rtb-console.png)

------------------------------
ran command:

aws ec2 create-route \
    --route-table-id $RT_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID \
    --region $REGION

![Screenshots](screenshots/rtb-route-gitbash.png)

result: successful route creation of 0.0.0.0/0 destination

![Screenshots](screenshots/rtb-route-console.png)

------------------------------
ran command:

aws ec2 associate-route-table \
    --subnet-id $SUBNET_ID \
    --route-table-id $RT_ID \
    --region $REGION

![Screenshots](screenshots/rtb-association-gitbash.png)

result: successfully associated the subnet with the route table

![Screenshots](screenshots/rtb-subnet-association.png)

------------------------------
ran command:

SG_ID=$(aws ec2 create-security-group \
    --group-name $SG_NAME \
    --description "Web Security Group" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text \
    --region $REGION)

echo "Security Group Created: $SG_ID"

![Screenshots](screenshots/sg-gitbash.png)

result: successful creation of SG

![Screenshots](screenshots/sg-console.png)

------------------------------
ran command:

aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region $REGION

![Screenshots](screenshots/sg-ingress.png)

result: successfully added HTTP inbound rule to SG

![Screenshots](screenshots/sg-http-rule-console.png)

------------------------------
ran command:

NACL_ID=$(aws ec2 create-network-acl \
    --vpc-id $VPC_ID \
    --query 'NetworkAcl.NetworkAclId' \
    --output text \
    --region $REGION)

echo "Network ACL Created: $NACL_ID"

![Screenshots](screenshots/nacl-creation-gitbash.png)

result: successful creation of NACL

![Screenshots](screenshots/nacl-creation-console.png)

------------------------------
ran command:

aws ec2 create-network-acl-entry \
    --network-acl-id $NACL_ID \
    --rule-number 100 \
    --protocol tcp \
    --port-range From=80,To=80 \
    --rule-action allow \
    --cidr-block 0.0.0.0/0 \
    --ingress \
    --region $REGION

![Screenshots](screenshots/nacl-entry-gitbash.png)

result: successfully created HTTP inbound rule on port 80

![Screenshots](screenshots/nacl-inbound-rule-console.png)

------------------------------
## Set up a private subnet, What I did in this step
navigated to subnet settings, created and filled out subnet details

![Screenshots](screenshots/subnet-details.png)

## Set up a private route table, What I did in this step
navigated to route table settings, created and filled out route table details

![Screenshots](screenshots/private-rtb-console.png)

associated the route table with the private subnet

![Screenshots](screenshots/subnet-rtb-association.png)

associated the private nacl with the private subnet

![Screenshots](screenshots/rtb-private-subnet-association.png)

## Set up a private network ACL, What I did in this step
navigated to network acls, created and filled out private network acls details

![Screenshots](screenshots/private-nacl-details.png)
associated the private nacl with the private subnet

![Screenshots](screenshots/private-nacl-subnet-association.png)

## End of project summary

Designed and implemented a multi-tier AWS networking environment by provisioning VPC infrastructure through the AWS CLI and AWS Management Console. Using CLI commands, I created and configured a VPC, public subnet, internet gateway, route tables, security groups, and network ACLs while validating resource creation through both the CLI and AWS Console.

To enhance network segmentation and security, I extended the architecture by creating a private subnet, private route table, and private network ACL. This project provided hands-on experience with AWS networking fundamentals, traffic routing, subnet isolation, access control, and infrastructure management through both automation and manual configuration methods.
