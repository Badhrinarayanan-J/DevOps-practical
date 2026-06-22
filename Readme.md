# DevOps Practical Project – End-to-End CI/CD Pipeline

# Architecture Overview

```text
Developer
   │
   ▼
GitHub Repository
   │
   ▼
Jenkins (SCM Polling Trigger)
   │
   ├── Build Docker Image
   ├── Trivy Security Scan
   ├── Push to Docker Hub
   └── Deploy to Kubernetes
   │
   ▼
Kubernetes (Minikube)
   │
   ├── Flask Application
   ├── Service Account
   ├── Network Policy
   ├── HPA
   └── Services
   │
   ▼
Prometheus
   │
   ▼
Grafana Dashboard
```

---

# Project Folder Structure

```text
devops-practical/
│
├── Jenkinsfile
│
├── app/
│   ├── Dockerfile
│   ├── app.py
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

# Technologies Used

| Category | Technology |
|----------|------------|
| SCM | GitHub |
| CI/CD | Jenkins |
| Containerization | Docker |
| Security Scan | Trivy |
| IaC | Terraform |
| Cloud | AWS EC2 |
| Orchestration | Kubernetes (Minikube) |
| Monitoring | Prometheus |
| Visualization | Grafana |
| Language | Python Flask |

---

# Step 1 – Create Flask Application

## app.py

```python
from flask import Flask, Response
from datetime import datetime
from prometheus_client import Counter, generate_latest
from prometheus_client import CONTENT_TYPE_LATEST

app = Flask(__name__)

@app.route('/')
def home():
    return f'''
    <h1>DevOps Practical Demo Application</h1>
    <p>Version: V2</p>
    <p>Current Time: {datetime.now()}</p>
    '''

@app.route('/health')
def health():
    return {"status": "UP"}

@app.route("/metrics")
def metrics():
    return Response(
        generate_latest(),
        mimetype=CONTENT_TYPE_LATEST
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

## requirements.txt

```text
flask==3.0.3
gunicorn==23.0.0
prometheus-client==0.22.1
```

---

# Step 2 – Dockerize Application

## Dockerfile

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN useradd -m appuser
USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

Build:

```bash
docker build -t flask-demo:v1 .
```

---

# Step 3 – Provision AWS Infrastructure using Terraform

## Resources Created

| Resource | Purpose |
|-----------|---------|
| EC2 Instance | Jenkins Host |
| Security Group | Access Control |
| Key Pair | Secure SSH Access |

Example Output:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

Terraform Output:

```text
instance_id = "i-xxxxxxxx"
public_ip = "xx.xx.xx.xx"
```

---

# Step 4 – Jenkins Pipeline

## Jenkins Credentials

| Credential | Purpose |
|------------|---------|
| GitHub | Repository Access |
| DockerHub | Push Images |

## Jenkinsfile

```groovy
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                git 'REPOSITORY_URL'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t USER/flask-demo:v1 app/'
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image USER/flask-demo:v1'
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push USER/flask-demo:v1'
            }
        }

        stage('Deploy') {
            steps {
                sh 'kubectl apply -f k8s/'
            }
        }
    }
}
```

---

# Step 5 – Kubernetes Deployment

## Deployment Features

- 2 Replicas
- Service Account
- Readiness Probe
- Liveness Probe
- Security Context
- Non-Root Container

## deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
```

## service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  type: NodePort
```

## serviceaccount.yaml

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: flask-sa
```

---

# Step 6 – Horizontal Pod Autoscaler

## hpa.yaml

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: flask-app-hpa
spec:
  minReplicas: 2
  maxReplicas: 5
```

Purpose:

- Automatically scale pods
- Improve availability
- Handle load spikes

---

# Step 7 – Network Security

## networkpolicy.yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: flask-app-network-policy
```

Benefits:

- Restricts unwanted traffic
- Improves cluster security
- Enforces least-access communication

---

# Step 8 – Prometheus Monitoring

## prometheus.yml

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "flask-app"
    metrics_path: /metrics
    static_configs:
      - targets:
        - "192.168.49.2:30135"
```

Validation:

```bash
curl http://$(minikube ip):30135/metrics
```

---

# Step 9 – Grafana Dashboard

## Dashboard Panels

| Panel | Purpose |
|---------|---------|
| Application Status | Application Health |
| CPU Usage | Resource Monitoring |
| Memory Usage | Memory Consumption |

Grafana Data Source:

```text
Prometheus
```

---

# Step 10 – End-to-End CI/CD Validation

## Test Scenario

1. Modify application code.
2. Commit changes.
3. Push to GitHub.
4. Jenkins Poll SCM detects change.
5. Pipeline starts automatically.
6. Docker image rebuilt.
7. Trivy security scan executed.
8. Image pushed to Docker Hub.
9. Kubernetes deployment updated.
10. Prometheus continues scraping.
11. Grafana reflects latest metrics.

Result:

✅ Fully automated CI/CD workflow.

---

# Security Controls Implemented

| Control | Status |
|----------|---------|
| Trivy Scan | ✅ |
| Non-root Container | ✅ |
| Service Account | ✅ |
| Network Policy | ✅ |
| Kubernetes Probes | ✅ |
| DockerHub Credentials | ✅ |

---

# Monitoring Verification

| Component | Status |
|------------|---------|
| Flask App | ✅ |
| Prometheus | ✅ |
| Grafana | ✅ |
| Dashboard | ✅ |
| Metrics Endpoint | ✅ |

---

# Disaster Recovery Strategy

- Infrastructure recreated using Terraform.
- Source code stored in GitHub.
- Jenkins rebuilds application.
- Docker images available in Docker Hub.
- Kubernetes manifests stored in Git.

Estimated RTO:

```text
15–30 Minutes
```

---

# Cost Optimization

### Optimization 1

Use Spot Instances for non-production workloads.

### Optimization 2

Configure CPU and memory requests/limits correctly.

### Optimization 3

Use HPA to scale only when needed.

---

# Future Improvements

- Deploy Jenkins on AWS EC2
- Use GitHub Webhooks instead of SCM Polling
- Store Terraform state remotely in S3
- Implement HTTPS with Ingress Controller
- Add Alertmanager notifications

---

# Final Outcome

Successfully implemented:

- Infrastructure as Code
- Containerization
- CI/CD Automation
- Security Scanning
- Kubernetes Deployment
- Monitoring & Observability
- Auto Scaling
- Network Security

End-to-End DevOps Pipeline completed successfully.

---

Regards,

**Badhrinarayanan J**  
**DevOps Engineer Enthusiast**
