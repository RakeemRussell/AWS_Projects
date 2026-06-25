#!/bin/bash
set -eu

# Variables
REGION="us-east-1"
VPC_CIDR="10.90.0.0/16"
PUBLIC_SUBNET_CIDR="10.90.1.0/24"
PRIVATE_SUBNET_CIDR="10.90.10.0/24"

VPC_NAME="vpc_us_east_1"

PUBLIC_SUBNET_NAME="Public_Subnet_01"
PRIVATE_SUBNET_NAME="Private_Subnet_01"

IGW_NAME="IGW_US_East_1"

PUBLIC_RT_NAME="Public_Route_Table"
PRIVATE_RT_NAME="Private_Route_Table"

SG_NAME="Public_SG_01"

PUBLIC_NACL_NAME="Public_NACL"
PRIVATE_NACL_NAME="Private_NACL"


# Create VPC
echo "Creating VPC..."

VPC_ID=$(aws ec2 create-vpc \
    --cidr-block $VPC_CIDR \
    --query 'Vpc.VpcId' \
    --output text \
    --region $REGION)

echo "VPC Created: $VPC_ID"

# Tag VPC
aws ec2 create-tags \
    --resources $VPC_ID \
    --tags Key=Name,Value=$VPC_NAME \
    --region $REGION

echo "VPC Tagged"

# Create Public Subnet
echo "Creating Public Subnet..."

PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $PUBLIC_SUBNET_CIDR \
    --query 'Subnet.SubnetId' \
    --output text \
    --region $REGION)

echo "Public Subnet Created: $PUBLIC_SUBNET_ID"

# Tag Public Subnet
aws ec2 create-tags \
    --resources $PUBLIC_SUBNET_ID \
    --tags Key=Name,Value=$PUBLIC_SUBNET_NAME \
    --region $REGION

echo "Public Subnet Tagged"

echo "Creating Private Subnet..."

# Create Private Subnet
PRIVATE_SUBNET_ID=$(aws ec2 create-subnet \
    --vpc-id $VPC_ID \
    --cidr-block $PRIVATE_SUBNET_CIDR \
    --query 'Subnet.SubnetId' \
    --output text \
    --region $REGION)

echo "Private Subnet Created: $PRIVATE_SUBNET_ID"

# Tag Private Subnet
aws ec2 create-tags \
    --resources $PRIVATE_SUBNET_ID \
    --tags Key=Name,Value=$PRIVATE_SUBNET_NAME \
    --region $REGION

echo "Private Subnet Tagged"

# Disable Public IP Assignment For Private Subnet
aws ec2 modify-subnet-attribute \
    --subnet-id $PRIVATE_SUBNET_ID \
    --no-map-public-ip-on-launch \
    --region $REGION

echo "Private Subnet Public IP Assignment Disabled"

# Create Internet Gateway
echo "Creating Internet Gateway..."

IGW_ID=$(aws ec2 create-internet-gateway \
    --query 'InternetGateway.InternetGatewayId' \
    --output text \
    --region $REGION)

echo "Internet Gateway Created: $IGW_ID"

# Tag IGW
aws ec2 create-tags \
    --resources $IGW_ID \
    --tags Key=Name,Value=$IGW_NAME \
    --region $REGION

echo "Internet Gateway Tagged"

# Attach Internet Gateway
aws ec2 attach-internet-gateway \
    --internet-gateway-id $IGW_ID \
    --vpc-id $VPC_ID \
    --region $REGION

echo "Internet Gateway Attached"

# Create Route Table
echo "Creating Route Table..."

Public_RT_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --query 'RouteTable.RouteTableId' \
    --output text \
    --region $REGION)

echo "Public Route Table Created: $Public_RT_ID"

# Tag Public Route Table
aws ec2 create-tags \
    --resources $Public_RT_ID \
    --tags Key=Name,Value=$PUBLIC_RT_NAME \
    --region $REGION

echo "Public Route Table Tagged"

# Create Public Default Route
aws ec2 create-route \
    --route-table-id $Public_RT_ID \
    --destination-cidr-block 0.0.0.0/0 \
    --gateway-id $IGW_ID \
    --region $REGION

echo "Default Route Added"

# Associate Public Route Table with Public Subnet
aws ec2 associate-route-table \
    --subnet-id $PUBLIC_SUBNET_ID \
    --route-table-id $Public_RT_ID \
    --region $REGION

echo "Route Table Associated"

# Create Private Route Table
echo "Creating Private Route Table..."

PRIVATE_RT_ID=$(aws ec2 create-route-table \
    --vpc-id $VPC_ID \
    --query 'RouteTable.RouteTableId' \
    --output text \
    --region $REGION)

echo "Private Route Table Created: $PRIVATE_RT_ID"

# Tag Private Route Table
aws ec2 create-tags \
    --resources $PRIVATE_RT_ID \
    --tags Key=Name,Value=$PRIVATE_RT_NAME \
    --region $REGION

echo "Private Route Table Tagged"

# Associate Private Route Table
aws ec2 associate-route-table \
    --subnet-id $PRIVATE_SUBNET_ID \
    --route-table-id $PRIVATE_RT_ID \
    --region $REGION

echo "Private Route Table Associated"

# Create Security Group
echo "Creating Security Group..."

SG_ID=$(aws ec2 create-security-group \
    --group-name $SG_NAME \
    --description "Web Security Group" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text \
    --region $REGION)

echo "Security Group Created: $SG_ID"

# Tag SG
aws ec2 create-tags \
    --resources $SG_ID \
    --tags Key=Name,Value=$SG_NAME \
    --region $REGION

echo "Security Group Tagged"

# Allow HTTP Traffic for Public SG
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0 \
    --region $REGION

echo "HTTP Rule Added"

# Create Public Network ACL
echo "Creating Public Network ACL..."

PUBLIC_NACL_ID=$(aws ec2 create-network-acl \
    --vpc-id $VPC_ID \
    --query 'NetworkAcl.NetworkAclId' \
    --output text \
    --region $REGION)

echo "Public Network ACL Created: $PUBLIC_NACL_ID"

# Tag Public NACL
aws ec2 create-tags \
    --resources $PUBLIC_NACL_ID \
    --tags Key=Name,Value=$PUBLIC_NACL_NAME \
    --region $REGION

echo "Public Network ACL Tagged"

# Find & Replace Public Subnet NACL
PUBLIC_NACL_ASSOC_ID=$(aws ec2 describe-network-acls \
    --filters Name=association.subnet-id,Values=$PUBLIC_SUBNET_ID \
    --query 'NetworkAcls[0].Associations[0].NetworkAclAssociationId' \
    --output text \
    --region $REGION)

aws ec2 replace-network-acl-association \
    --association-id $PUBLIC_NACL_ASSOC_ID \
    --network-acl-id $PUBLIC_NACL_ID \
    --region $REGION

# Create HTTP Inbound Public NACL Rule
aws ec2 create-network-acl-entry \
    --network-acl-id $PUBLIC_NACL_ID \
    --rule-number 100 \
    --protocol tcp \
    --port-range From=80,To=80 \
    --rule-action allow \
    --cidr-block 0.0.0.0/0 \
    --ingress \
    --region $REGION

# Create Ephemeral Outbound Public NACL Rule
aws ec2 create-network-acl-entry \
    --network-acl-id $PUBLIC_NACL_ID \
    --rule-number 100 \
    --protocol tcp \
    --port-range From=1024,To=65535 \
    --rule-action allow \
    --cidr-block 0.0.0.0/0 \
    --egress \
    --region $REGION

echo "Public Network ACL Rules Added"

# Create Private Network ACL
PRIVATE_NACL_ID=$(aws ec2 create-network-acl \
    --vpc-id $VPC_ID \
    --query 'NetworkAcl.NetworkAclId' \
    --output text \
    --region $REGION)

echo "Private Network ACL Created: $PRIVATE_NACL_ID"

# Tag Private NACL
aws ec2 create-tags \
    --resources $PRIVATE_NACL_ID \
    --tags Key=Name,Value=$PRIVATE_NACL_NAME \
    --region $REGION

echo "Private Network ACL Tagged"

# Return Private Subnet Current NACL Association
PRIVATE_NACL_ASSOC_ID=$(aws ec2 describe-network-acls \
    --filters Name=association.subnet-id,Values=$PRIVATE_SUBNET_ID \
    --query 'NetworkAcls[0].Associations[0].NetworkAclAssociationId' \
    --output text \
    --region $REGION)

echo "Association Found: $PRIVATE_NACL_ASSOC_ID"

# Associate Private Subnet with Private NACL
aws ec2 replace-network-acl-association \
    --association-id $PRIVATE_NACL_ASSOC_ID \
    --network-acl-id $PRIVATE_NACL_ID \
    --region $REGION

# Create Inbound from VPC to Private NACL Rule
aws ec2 create-network-acl-entry \
    --network-acl-id $PRIVATE_NACL_ID \
    --rule-number 100 \
    --protocol -1 \
    --rule-action allow \
    --cidr-block $VPC_CIDR \
    --ingress \
    --region $REGION

# Create Outbound to Anywhere Private NACL Rule
aws ec2 create-network-acl-entry \
    --network-acl-id $PRIVATE_NACL_ID \
    --rule-number 100 \
    --protocol -1 \
    --rule-action allow \
    --cidr-block 0.0.0.0/0 \
    --egress \
    --region $REGION

# Summary
echo ""
echo "===== DEPLOYMENT COMPLETE ====="
echo "VPC ID: $VPC_ID"
echo "Public Subnet ID: $PUBLIC_SUBNET_ID"
echo "Private Subnet ID: $PRIVATE_SUBNET_ID"
echo "IGW ID: $IGW_ID"
echo "Public Route Table ID: $Public_RT_ID"
echo "Private Route Table ID: $PRIVATE_RT_ID"
echo "Security Group ID: $SG_ID"
echo "Public Network ID: $PUBLIC_NACL_ID"
echo "Private Network ID: $PRIVATE_NACL_ID"