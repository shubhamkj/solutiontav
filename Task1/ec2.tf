resource "aws_instance" "jenkins" {
	ami = "ami-062b5f37ab617e3cd"
	# ami = "ami-085d15593174f2582"
	instance_type = "t3a.large"
	subnet_id = module.vpc.public_subnets[0]
	iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
	user_data = <<EOF
		#!/bin/bash
		sudo yum update -y
		sudo yum install wget -y
		sudo amazon-linux-extras install java-openjdk11 -y
		sudo amazon-linux-extras install epel -y
		sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
		sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
		sudo yum install jenkins -y
		sudo service jenkins start
		curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
		chmod +x ./kubectl
		sudo mv ./kubectl /usr/local/bin/kubectl
	EOF
	ebs_block_device {
	  volume_type = "gp3"
	  device_name = "/dev/xvda"
	}
	tags = {

		Name = "Jenkins-master"
		Terraform = "true"
	}
}

resource "aws_instance" "minikube" {
	ami = "ami-062b5f37ab617e3cd"
	instance_type = "t3a.large"
	subnet_id = module.vpc.private_subnets[0]
	iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
	user_data = <<EOF
		curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
		chmod +x ./kubectl
		sudo mv ./kubectl /usr/local/bin/kubectl
		sudo apt-get update && \
	    sudo apt-get install docker.io -y
	    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
	    minikube version
	EOF

	ebs_block_device {
	  volume_type = "gp3"
	  device_name = "/dev/xvda"
	}

	tags = {

		Name = "Minikube server"
		Terraform = "true"
	}
}