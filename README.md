Server-App README
# FYP Server App

This repository contains the server-side application for the DevOps Capstone Project. 
It provides a backend service that generates a file and sends it to the client application. The app is containerized with Docker and deployed on AWS EC2 using Terraform.

---

## **Prerequisites**

- Git
- Docker & Docker Compose
- Python 3.11+
- AWS CLI configured with access key and secret
- Terraform 1.0+ installed

---

## **Repository Structure**
server-app/
 ├── app/
 │ └── server.py
 ├── terraform/
 │ ├── main.tf
 │ ├── variables.tf
 │ ├── outputs.tf
 │ └── provider.tf
 ├── docker-compose.yml
 ├── Dockerfile
 ├── requirements.txt
 └── README.md

---

## **Terraform (Infrastructure as Code)**

1. Configure AWS credentials:

```bash
aws configure
Initialize Terraform:


cd terraform
terraform init
Apply Terraform to create EC2, VPC, security groups, and subnet:


terraform apply -var="key_name=<YOUR_KEY_PAIR_NAME>"
Outputs:


server_public_ip – Public IP of the server EC2


server_private_ip – Private IP of the server EC2


vpc_id – VPC ID


Make sure the EC2 security group allows TCP ports 5000, 3020 (Grafana), and 22 (SSH).

Docker Setup
Build and run the container:


docker-compose up --build -d
Verify the container is running:


docker ps
Access the server application:


http://<SERVER_PUBLIC_IP>:5000
Expected output:
{"message": "Server app works. FYP ended."}

CI/CD Pipeline
The server repo is connected to GitHub Actions.
Any push to main branch will:
Build Docker image
Push it to Docker Hub
Pull the image on EC2 via self-hosted runner
Redeploy container
Send Slack notification

Monitoring (Optional)
Grafana and cAdvisor are installed on the EC2 to monitor container and system metrics.

Access Grafana at:
http://<SERVER_PUBLIC_IP>:3020

Troubleshooting
Docker permission issues: Use sudo docker ... if permission denied.
Server not reachable: Check security groups for port 5000.
Terraform errors: Verify AWS credentials and correct key pair name.

