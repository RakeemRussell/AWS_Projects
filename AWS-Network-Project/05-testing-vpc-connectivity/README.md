# Testing VPC Connectivity

## Project Overview

![Architecture Diagram](docs/architecture-diagram.png)

This project demonstrates the deployment of a secure and segmented AWS network environment using Infrastructure as Code (IaC) with Terraform.

The environment was deployed in the us-east-1 (N. Virginia) region using a custom VPC (10.90.0.0/16) containing separate public and private subnets. A public EC2 instance was placed in the public subnet with internet access through an Internet Gateway, while a private EC2 instance was deployed in an isolated private subnet without direct internet exposure.

Route tables, Security Groups, and Network ACLs were configured to control traffic flow and enforce layered security boundaries between resources. Terraform was used to automate infrastructure deployment and manage dependencies between AWS networking components.

This architecture demonstrates foundational cloud engineering concepts including network segmentation, defense-in-depth security, Infrastructure as Code, and reproducible cloud deployments.

## Project Objectives

- Deploy AWS infrastructure using Terraform.
- Create public and private subnets within a custom VPC.
- Configure routing between network components.
- Restrict access using Security Groups and NACLs.
- Launch EC2 instances in separate security zones.
- Validate connectivity and traffic flow between resources.

## Architecture Overview

This environment was deployed in the us-east-1 (N. Virginia) AWS region using a custom VPC with a CIDR range of 10.90.0.0/16.

The architecture was designed to demonstrate secure network segmentation by separating public-facing resources from internal resources.

## Network Layout

VPC: CIDR_10.90.0.0/16 ----------------> AZ_us-east-1 --> PURPOSE_Isolated network environment

PUBLIC SUBNET: CIDR_10.90.1.0/24 ---> AZ_us-east-1a -> PURPOSE_Hosts internet-facing resources

PRIVATE SUBNET: CIDR_10.90.11.0/24 -> AZ_us-east-1a -> PURPOSE_Hosts internal resources

## Traffic Flow

1. Internet traffic enters the VPC through the Internet Gateway.

2. The Public Route Table contains a default route (`0.0.0.0/0`)
    pointing to the Internet Gateway.
3. The Public EC2 instance resides in the public subnet and receives
    internet access through this route.
4. The Private Route Table does not contain an Internet Gateway route,
    preventing direct internet connectivity.
5. The Private EC2 instance remains isolated inside the private subnet.
6. Security Groups provide stateful instance-level filtering while
    Network ACLs provide stateless subnet-level filtering.

## Technologies Used

### Cloud Services

- AWS VPC
- Subnet
- AWS IGW
- AWS RTBs
- AWS Security Groups
- AWS NACL
- Amazon EC2

### Development and Operations Tools

- Git
- GitHub
- Visual Studio Code
- AWS Management Console

### Networking Concepts

- CIDR Addressing
- Subnetting
- Routing
- Stateful Firewalls
- Stateless Firewalls
- Network Segmentation

### Skills Demonstrated

- Designed and deployed a custom VPC using the 10.90.0.0/16 CIDR range.
- Implemented public and private subnets to enforce network isolation.
- Configured route tables and route associations to control traffic flow.

### Infrastructure as Code

- Automated infrastructure deployment using Terraform.
- Managed resource dependencies between VPC components.
- Used version-controlled infrastructure definitions through Git and GitHub.

### Security

- Implemented Security Groups as stateful firewalls.
- Configured Network ACLs as stateless subnet-level firewalls.
- Applied defense-in-depth security principles through multiple security layers.

### Troubleshooting and Validation

- Verified Terraform deployments in the AWS Console.
- Validated route table associations and routing behavior.
- Confirmed Security Group ingress and egress rules.
- Verified Network ACL rule processing and subnet associations.
- Ensured EC2 instances were deployed into the correct subnets.
- Tested connectivity to confirm expected network behavior.

### Documentation and Collaboration

- Created technical documentation and architecture diagrams.
- Maintained project source code using Git version control.

## Resources_with_Terraform Screenshots

**resource "aws_vpc" "us-east-1"** (Provides isolated network environment)

![Screenshots](screenshots/vpc-build.png)

**resource "aws_subnet" "public_subnet"**(Hosts internet-facing resources)

![Screenshots](screenshots/subnet-public-build.png)

**resource "aws_subnet" "private_subnet"**(Hosts internal resources)

![Screenshots](screenshots/subnet-private-build.png)

**resource "aws_internet_gateway" "igw_us_east_1"**(Enables internet access for public resources)

![Screenshots](screenshots/igw-build.png)

**resource "aws_route_table" "public-rtb"**(Routes traffic to the internet)

![Screenshots](screenshots/rtb-public-build.png)

**resource "aws_route_table" "private-rtb"**(Restricts internet access)

![Screenshots](screenshots/rtb-private-build.png)

**resource "aws_route_table_association" "public_association"**(Associates a subnet with a route table, determining how traffic is routed for resources in that subnet)

![Screenshots](screenshots/rtb-association-public-build.png)

**resource "aws_route_table_association" "private_association"**(Associates a subnet with a route table, determining how traffic is routed for resources in that subnet)

![Screenshots](screenshots/rtb-association-private-build.png)

**resource "aws_security_group" "sg_public"**(Stateful instance-level firewall)

![Screenshots](screenshots/sg-public-build.png)

**resource "aws_security_group" "sg_private"**(Stateful instance-level firewall)

![Screenshots](screenshots/sg-private-build.png)

**resource "aws_network_acl" "public_nacl"**(Stateless subnet-level firewall)

![Screenshots](screenshots/nacl-public-build.png)

**resource "aws_network_acl" "private_nacl"**(Stateless subnet-level firewall)

![Screenshots](screenshots/nacl-private-build.png)

**resource "aws_instance" "public_ec2"**(Used to validate connectivity)

![Screenshots](screenshots/ec2-public-build.png)

**resource "aws_instance" "private_ec2"**(Used to validate connectivity)

![Screenshots](screenshots/ec2-private-build.png)

## Security_Group_And_NACL_Rules Screenshots

## Testing_VPC_Connectivity Screenshots

![Screenshots](screenshots/testing-vpc-connectivity-diagram.png)

**ec2 public instance connect**
![Screenshots](screenshots/ec2-public-connect.png)

**ec2 public terminal**
![Screenshots](screenshots/ec2-public-terminal.png)
![Screenshots](screenshots/client-to-public-server-connectivity-diagram.png)

**ec2 public and private connectivity ping test**
![Screenshots](screenshots/ec2-public-and-private-connectivity-ping-test.png)
![Screenshots](screenshots/public-to-private-server-connectivity-diagram.png)

**ec2 public and internet connectivity curl test**
![Screenshots](screenshots/ec2-public-and-internet-connectivity-curl-test.png)
![Screenshots](screenshots/public-server-to-internet-connectivity-diagram.png)
