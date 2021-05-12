#Create AWS Provider
provider "aws" {
  region = var.aws_region
  version = "~> 3.37"
}

# Create AWS VPC
resource "aws_vpc" "test-vpc" {
    cidr_block           = "10.0.0.0/16"
    instance_tenancy     = var.instance_tenancy

    tags = {
        Name = "test-vpc"
    }
}

# Create Public Subnet
resource "aws_subnet" "test-pub-subnet" {
    vpc_id                  = aws_vpc.test-vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = var.az1
    map_public_ip_on_launch = true

    tags = {
        Name = "test-pub-subnet"
    }
}

#Create Internet Gateway
resource "aws_internet_gateway" "test-igw" {
    vpc_id = aws_vpc.test-vpc.id

    tags = {
        Name = "test-igw"
    }
}
#Create Routing Table
resource "aws_route_table" "test-rtb" {
    vpc_id     = aws_vpc.test-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test-igw.id
    }

    tags = {
        Name = "test-rtb"
    }
}

#Create Route Table Association
resource "aws_route_table_association" "test-rtba" {
    route_table_id = aws_route_table.test-rtb.id
    subnet_id = aws_subnet.test-pub-subnet.id
}

#Create Security Group
resource "aws_security_group" "test-sg" {
    name        = "test-sg"
    description = "test security group"
    vpc_id      = aws_vpc.test-vpc.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    ingress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
}

    egress {
        from_port       = 0
        to_port         = 65535
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "test-sg"
    }
}

# Create Launch Configuration

resource "aws_launch_configuration" "test-lc" {
  name_prefix   = "test-lc-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_groups = [aws_security_group.test-sg.id]
  associate_public_ip_address = true
  key_name = "test-key"
  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    delete_on_termination = true

  }
  lifecycle {
    create_before_destroy = true
  }

}

# Create AWS Autoscalling Group
resource "aws_autoscaling_group" "test-asg" {
    desired_capacity          = var.desired_capacity
    health_check_grace_period = var.health_check_grace_period
    health_check_type         = var.health_check_type
    max_size                  = var.max_size
    min_size                  = var.min_size
    name                      = "testasg"
    vpc_zone_identifier       = [aws_subnet.test-pub-subnet.id]
    launch_configuration = aws_launch_configuration.test-lc.name
    lifecycle {
     create_before_destroy = true
   }

}
