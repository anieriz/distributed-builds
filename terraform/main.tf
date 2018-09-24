provider "aws" {}

data "template_file" "policy" {
  template = "${file("templates/policy.tpl")}"
}
resource "aws_iam_role" "this" {
  name = "${var.project}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_role_policy" "this" {
  name   = "${var.project}"
  role   = "${aws_iam_role.this.id}"
  policy = "${data.template_file.policy.rendered}"
}
resource "aws_iam_instance_profile" "this" {
  name = "${var.project}"
  role = "${aws_iam_role.this.name}"
}

resource "aws_security_group" "this" {
  name        = "${var.project}"
  description = "firewall for jenkins"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                     = "${var.ami}"
  instance_type           = "${var.instance_type}"
  subnet_id               = "${var.subnet_id}"
  key_name                = "${var.key_name}"
  monitoring              = true
  vpc_security_group_ids  = ["${aws_security_group.this.id}"]
  iam_instance_profile    = "${aws_iam_instance_profile.this.name}"

  root_block_device {
    delete_on_termination = true
    volume_size           = 30
    volume_type           = "gp2"
  }
  ebs_block_device {
    device_name           = "/dev/sdf"
    delete_on_termination = true
    volume_size           = 30
    volume_type           = "gp2"
  }

  tags {
    Name     = "${var.project}"
  }
}