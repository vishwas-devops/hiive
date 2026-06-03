data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_iam_role" "this" {
  name = "${var.name}-workstation-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "eks" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-workstation-profile"
  role = aws_iam_role.this.name
}

resource "aws_security_group" "this" {
  name        = "${var.name}-workstation-sg"
  description = "Private workstation security group"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow HTTPS to VPC endpoints"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-workstation-sg"
  })
}

resource "aws_instance" "this" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.this.name
  vpc_security_group_ids      = [aws_security_group.this.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y unzip git docker

              curl -LO "https://dl.k8s.io/release/v1.30.0/bin/linux/amd64/kubectl"
              install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

              curl -fsSL https://releases.hashicorp.com/terraform/1.8.5/terraform_1.8.5_linux_amd64.zip -o terraform.zip
              unzip terraform.zip
              mv terraform /usr/local/bin/terraform

              systemctl enable docker
              systemctl start docker
              usermod -aG docker ec2-user
              EOF

  tags = merge(var.tags, {
    Name = "${var.name}-private-workstation"
  })
}
