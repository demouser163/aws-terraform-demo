#Create AWS Provider
provider "aws" {
  region = var.aws_region
  version = "~> 3.37"
}

# Create AWS VPC
resource "aws_vpc" "test-vpc" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support   = true
    instance_tenancy     = var.instance_tenancy

    tags = {
        Name = "test-vpc"
    }
}

# Create Public Subnet
resource "aws_subnet" "test-publicsubnet-one" {
    vpc_id                  = aws_vpc.test-vpc.id
    cidr_block              = "10.0.0.0/24"
    availability_zone       = var.az1
    map_public_ip_on_launch = false

    tags = {
        Name = "test-publicsubnet-one"
    }
}

resource "aws_subnet" "test-publicsubnet-two" {
    vpc_id                  = aws_vpc.test-vpc.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = var.az2
    map_public_ip_on_launch = false

    tags = {
        Name = "test-publicsubnet-two"
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
resource "aws_route_table" "test-rt-one" {
    vpc_id     = aws_vpc.test-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test-igw.id
    }

    tags = {
        Name = "test-rt-one"
    }
}

resource "aws_route_table" "test-rt-two" {
    vpc_id     = aws_vpc.test-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test-igw.id
    }

    tags = {
        Name = "test-rt-two"
    }
}

#Create Route Table Association
resource "aws_route_table_association" "test-rtb-one" {
    route_table_id = aws_route_table.test-rt-one.id
    subnet_id = aws_subnet.test-publicsubnet-one.id
}

resource "aws_route_table_association" "test-rtb-two" {
    route_table_id = aws_route_table.test-rt-two.id
    subnet_id = aws_subnet.test-publicsubnet-two.id
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
        cidr_blocks     = ["10.0.0.0/16", "116.87.195.28/32"]
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

# Create Launch Template
resource "aws_launch_template" "test-lt" {
    name_prefix   = "testlt"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    block_device_mappings {
    device_name = var.device_name

    ebs {
      volume_size = var.volume_size
    }
  }

    credit_specification {
    cpu_credits = var.cpu_credits
  }

    disable_api_termination = true
    monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
  }
    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "test-vm"
    }
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
    vpc_zone_identifier       = [aws_subnet.test-publicsubnet-one.id, aws_subnet.test-publicsubnet-two.id]
    launch_template {
      id      = aws_launch_template.test-lt.id
      version = "$Latest"
    }

}
