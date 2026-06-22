# 🚀 DevOps Practical Project - End-to-End CI/CD Pipeline

![DevOps](https://img.shields.io/badge/DevOps-End--to--End-blue)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5)
![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C)
![Grafana](https://img.shields.io/badge/Grafana-Visualization-F46800)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900)

---

# 📖 Project Overview

This project demonstrates a complete end-to-end DevOps workflow using modern industry-standard tools and best practices.

The objective was to automate the entire software delivery lifecycle:

* Source Code Management using GitHub
* CI/CD using Jenkins
* Containerization using Docker
* Security Scanning using Trivy
* Infrastructure Provisioning using Terraform
* Application Deployment using Kubernetes (Minikube)
* Monitoring using Prometheus
* Visualization using Grafana
* Auto Scaling using HPA
* Security Hardening using Service Accounts, Network Policies, and Non-Root Containers

---

# 🏗️ Solution Architecture

```text
                        ┌─────────────┐
                        │ Developer   │
                        └──────┬──────┘
                               │
                               ▼
                        ┌─────────────┐
                        │   GitHub    │
                        └──────┬──────┘
                               │
                               ▼
                        ┌─────────────┐
                        │   Jenkins   │
                        └──────┬──────┘
                               │
          ┌────────────────────┼────────────────────┐
          │                    │                    │
          ▼                    ▼                    ▼
 ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
 │ Docker Build │     │ Trivy Scan  │     │ Docker Push  │
 └──────┬───────┘     └──────────────┘     └──────┬───────┘
        │                                          │
        └────────────────────┬─────────────────────┘
                             ▼
                    ┌────────────────┐
                    │ Docker Hub     │
                    └──────┬─────────┘
                           │
                           ▼
                    ┌────────────────┐
                    │ Kubernetes     │
                    │ (Minikube)     │
                    └──────┬─────────┘
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
 ┌─────────────┐   ┌─────────────┐   ┌─────────────┐
 │ Flask App   │   │ Prometheus  │   │  Grafana    │
 └─────────────┘   └─────────────┘   └─────────────┘
```

---

# 📂 Project Structure

```text
devops-practical/
│
├── README.md
├── Jenkinsfile
│
├── app/
│   ├── app.py
│   ├── Dockerfile
│   └── requirements.txt
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   ├── output.tf
│   ├── outputs.tf
│   └── devops-practical-key.pub
│
├── k8s/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   ├── hpa.yaml
│   └── networkpolicy.yaml
│
└── monitoring/
    ├── prometheus.yml
    ├── prometheus-deployment.yaml
    ├── prometheus-service.yaml
    ├── grafana-deployment.yaml
    └── grafana-service.yaml
```

---

# 🛠️ Technologies Used

| Category               | Technology            |
| ---------------------- | --------------------- |
| Source Control         | GitHub                |
| CI/CD                  | Jenkins               |
| Containerization       | Docker                |
| Security Scanning      | Trivy                 |
| Infrastructure as Code | Terraform             |
| Cloud Provider         | AWS EC2               |
| Orchestration          | Kubernetes (Minikube) |
| Monitoring             | Prometheus            |
| Dashboarding           | Grafana               |
| Programming Language   | Python Flask          |

---

# 🚀 Step 1 - Application Development

## Flask Application

Features:

* Home Endpoint
* Health Check Endpoint
* Prometheus Metrics Endpoint

### Endpoints

| Endpoint | Purpose               |
| -------- | --------------------- |
| /        | Application Home Page |
| /health  | Health Check          |
| /metrics | Prometheus Metrics    |

---

# 🐳 Step 2 - Docker Containerization

### Objectives

* Package Flask Application
* Ensure Environment Consistency
* Run Application in Containers

### Security Controls

✅ Non-root User

```dockerfile
USER appuser
```

### Build

```bash
docker build -t flask-demo:v1 .
```

---

# ☁️ Step 3 - Infrastructure Provisioning with Terraform

Terraform was used to provision AWS resources.

### Resources Created

| Resource       | Purpose           |
| -------------- | ----------------- |
| EC2 Instance   | Compute           |
| Security Group | Network Access    |
| Key Pair       | Secure SSH Access |

### Terraform Workflow

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### Outputs

```text
instance_id = "i-xxxxxxxx"
public_ip   = "xx.xx.xx.xx"
```

---

# 🔄 Step 4 - Jenkins CI/CD Pipeline

## Pipeline Stages

| Stage        | Purpose               |
| ------------ | --------------------- |
| Checkout     | Pull Code             |
| Build        | Build Application     |
| Docker Build | Build Image           |
| Trivy Scan   | Security Validation   |
| Push Image   | Docker Hub Push       |
| Deploy       | Kubernetes Deployment |

### CI/CD Workflow

```text
Git Push
   ↓
Jenkins Trigger
   ↓
Build
   ↓
Docker Build
   ↓
Trivy Scan
   ↓
Docker Hub Push
   ↓
Kubernetes Deployment
```

---

# ☸️ Step 5 - Kubernetes Deployment

## Deployment Features

* 2 Replicas
* NodePort Service
* Readiness Probe
* Liveness Probe
* Service Account
* Security Context

### Deployment Validation

```bash
kubectl get pods
kubectl get svc
```

---

# 📈 Step 6 - Horizontal Pod Autoscaler

## HPA Configuration

| Setting       | Value |
| ------------- | ----- |
| Min Replicas  | 2     |
| Max Replicas  | 5     |
| CPU Threshold | 50%   |

### Validation

```bash
kubectl get hpa
```

---

# 🔒 Step 7 - Security Implementation

## S1 - Image Scanning

Implemented using:

```text
Trivy
```

Pipeline configured to perform image vulnerability scanning.

---

## S2 - Secrets Management

Secrets are not stored in source code.

Used:

* Jenkins Credentials Store
* Docker Hub Credentials

---

## S3 - Container Security

Container runs as non-root user.

Validation:

```bash
kubectl exec -it POD_NAME -- id
```

Output:

```text
uid=1000(appuser)
```

---

## S4 - Kubernetes RBAC

Dedicated Service Account:

```text
flask-sa
```

Used by deployment.

---

## S5 - Network Policy

NetworkPolicy implemented.

Benefits:

* Restricts unwanted traffic
* Improves security posture
* Enforces least privilege access

---

# 📊 Step 8 - Prometheus Monitoring

## Metrics Collection

Prometheus scrapes metrics from:

```text
/metrics
```

### Validation

```bash
curl http://<app-url>/metrics
```

Expected:

```text
# HELP
# TYPE
```

---

# 📉 Step 9 - Grafana Dashboard

Grafana integrated with Prometheus.

### Dashboard Panels

| Panel              | Description          |
| ------------------ | -------------------- |
| Application Status | Service Availability |
| CPU Usage          | CPU Monitoring       |
| Memory Usage       | Memory Monitoring    |

---

# ✅ Step 10 - End-to-End Validation

## Scenario

A code change was made to the Flask application.

Example:

```html
Version: V1
```

Changed To:

```html
Version: V2
```

### Validation Flow

```text
Developer Push
        ↓
GitHub
        ↓
Jenkins SCM Polling
        ↓
Pipeline Triggered
        ↓
Docker Image Rebuilt
        ↓
Trivy Scan Executed
        ↓
Docker Hub Push
        ↓
Kubernetes Deployment Updated
        ↓
Application Updated Successfully
```

Result:

✅ End-to-End CI/CD Successfully Validated

---

# 📡 Monitoring Validation

| Component         | Status |
| ----------------- | ------ |
| Flask Application | ✅      |
| Prometheus        | ✅      |
| Grafana           | ✅      |
| Dashboard         | ✅      |
| Metrics Endpoint  | ✅      |

---

# 🔄 Disaster Recovery Strategy

If the Kubernetes cluster becomes unavailable:

1. Recreate infrastructure using Terraform
2. Restore source code from GitHub
3. Redeploy application using Jenkins
4. Pull Docker images from Docker Hub
5. Reapply Kubernetes manifests

### Estimated RTO

```text
15 - 30 Minutes
```

---

# 💰 Cost Optimization

### Optimization 1

Use Spot Instances for non-production workloads.

### Optimization 2

Right-size CPU and Memory requests.

### Optimization 3

Use Horizontal Pod Autoscaler to scale only when required.

---

# 🔮 Future Enhancements

* Jenkins on AWS EC2
* GitHub Webhooks
* Terraform Remote Backend (S3)
* Kubernetes Ingress Controller
* HTTPS / SSL
* Alertmanager Integration
* Slack Notifications

---

# 🏆 Project Outcome

Successfully implemented:

✅ Infrastructure as Code

✅ Containerization

✅ CI/CD Automation

✅ Security Scanning

✅ Kubernetes Deployment

✅ Monitoring & Observability

✅ Horizontal Scaling

✅ Network Security

✅ End-to-End Automated Delivery Pipeline

---

# 📸 Screenshots

Add screenshots here:

* Jenkins Successful Pipeline
* Docker Hub Repository
* Terraform Outputs
* Kubernetes Pods
* Prometheus Targets
* Grafana Dashboard

---

# 👨‍💻 Author

## Regards,

### **Badhrinarayanan J**

### **DevOps Engineer Enthusiast 🚀**
