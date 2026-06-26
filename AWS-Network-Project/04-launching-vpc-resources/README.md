# Launching VPC Resources

## Project Overview

![Architecture Diagram](docs/image-2.png)

The first part of this project demonstrates how to build a secure AWS network infrastructure entirely through AWS CLI and Bash scripting. The goal was to automate network creation while learning AWS networking fundamentals and CLI automation. The second part I will create two EC2 instances one public the other private using the AWS console and place the public instance in the public subnet and the private instance in the private subnet.

## Technologies Used

### Cloud Services

- AWS VPC
- Subnet
- AWS IGW
- AWS RTBs
- Network ACL
- AWS Security Groups
- Amazon EC2

### Tools

- AWS CLI
- Git and GitHub
- VS Code
- AWS Management Console

### Skills Demonstrated

- Network Segmentation
- Infrastructure Automation
- Routing
- Access Control
- Bash Scripting
- Technical Documentation

### Troubleshooting Skills

- Validation in AWS Console
- Verification of associations
- Verification of routes
- Verification of NACLs
- Verification of Security Groups

## Screenshots

### Script Variables

![Screenshots](screenshots/script_variables.png)

#### Bash Command: VPC_ID=$(aws ec2 create-vpc \

![Screenshots](screenshots/vpc.png)

#### Bash Command: PUBLIC_SUBNET_ID=$(aws ec2 create-subnet \

#### Bash Command: PRIVATE_SUBNET_ID=$(aws ec2 create-subnet \

![Screenshots](screenshots/subnets.png)

#### Bash Command: aws ec2 modify-subnet-attribute \

![Screenshots](screenshots/disable_public_ip.png)

#### Bash Command: IGW_ID=$(aws ec2 create-internet-gateway \

![Screenshots](screenshots/igw.png)

#### Bash Command: aws ec2 attach-internet-gateway \

![Screenshots](screenshots/attached_internet_gateway.png)

#### Bash Command: Public_RT_ID=$(aws ec2 create-route-table \

#### Bash Command: PRIVATE_RT_ID=$(aws ec2 create-route-table \

![Screenshots](screenshots/route_tables.png)

#### Bash Command: aws ec2 create-route \

![Screenshots](screenshots/rt_public_default_route.png)

#### Bash Command: aws ec2 associate-route-table \

![Screenshots](screenshots/public_rt_public_subnet_associtation.png)

#### Bash Command:aws ec2 associate-route-table \

![Screenshots](screenshots/private_rt_private_subnet_association.png)

#### Bash Command: SG_ID=$(aws ec2 create-security-group \

![Screenshots](screenshots/public_sg.png)

#### Bash Command: aws ec2 authorize-security-group-ingress \

![Screenshots](screenshots/public_sg_http_traffic.png)

#### Bash Command: Public_NACL_ID=$(aws ec2 create-network-acl \

#### Bash Command: PRIVATE_NACL_ID=$(aws ec2 create-network-acl \

![Screenshots](screenshots/network_acls.png)

#### Bash Command: PUBLIC_NACL_ASSOC_ID=$(aws ec2 describe-network-acls \

![Screenshots](screenshots/public_nacl_public_subnet_associtation.png)

#### Bash Command: aws ec2 create-network-acl-entry \

![Screenshots](screenshots/public_nacl_inbound_rule.png)

#### Bash Command:aws ec2 create-network-acl-entry \

![Screenshots](screenshots/public_nacl_outbound_rule.png)

#### Bash Command: PRIVATE_NACL_ASSOC_ID=$(aws ec2 describe-network-acls \

#### Bash Command: aws ec2 replace-network-acl-association \

![Screenshots](screenshots/private_nacl_subnet_associtation.png)

#### Bash Command: aws ec2 create-network-acl-entry \

![Screenshots](screenshots/private_nacl_inbound_rule.png)

#### Bash Command:aws ec2 create-network-acl-entry \

![Screenshots](screenshots/private_nacl_outbound_rule.png)

#### AWS Console: public ec2(name and ami)

![Screenshots](screenshots/public_ec2.png)

#### AWS Console: public ec2(instance_type and key_pair)

![Screenshots](screenshots/public_ec2_02.png)

#### AWS Console: public ec2(network_settings)

![Screenshots](screenshots/public_ec2_03.png)

#### AWS Console: private ec2(name and ami)

![Screenshots](screenshots/private_ec2.png)

#### AWS Console: private ec2(instance_type and key_pair)

![Screenshots](screenshots/private_ec2_02.png)

#### AWS Console: private ec2(network_settings)

![Screenshots](screenshots/private_ec2_03.png)

#### AWS Console: created ec2 instances

![Screenshots](screenshots/ec2_instances.png)

## Full Source Code

The complete deployment script is available here:

[vpc-us-east-1.sh](scripts/vpc-us-east-1.sh)
