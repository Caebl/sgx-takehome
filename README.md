# SGX Senior DevOps Engineer – Take-Home Assignment

## Overview
This project demonstrates the deployment of a **GKE Autopilot cluster** using **Terraform**, hosting a sample application (`whoami`), and integrating **basic observability and monitoring** via Google Cloud Monitoring.

---

## Architecture

**Components**
- **Terraform** – Infrastructure as Code for provisioning a GKE Autopilot cluster.  
- **Google Kubernetes Engine (Autopilot)** – Manages nodes and scaling automatically.  
- **whoami container** – Lightweight HTTP app (Traefik image) used for connectivity and health tests.  
- **Google Cloud Monitoring** – Observability for metrics, pod health, and uptime checks.

**Workflow**
1. Terraform creates a GKE Autopilot cluster and supporting resources.  
2. `kubectl` deploys `whoami` as a LoadBalancer service.  
3. Cloud Monitoring dashboards visualize metrics and uptime health.

---

## Deployment Steps

### 1️ .Prerequisites
- Google Cloud SDK (`gcloud`)
- Terraform ≥ 1.6
- kubectl
- A Google Cloud project with billing enabled (e.g., `sgx-autopilot-lab`) and GKE and IAM APIs enabled

### 2️.Configure gcloud
gcloud auth login --no-launch-browser

gcloud config set project sgx-autopilot-lab

gcloud config set compute/region asia-southeast1


### 3.️Terraform Deployment
cd ~/sgx-takehome/terraform

terraform init

terraform apply -auto-approve -var="project_id=sgx-autopilot-lab"


### 4️.Connect to the GKE Cluster
gcloud container clusters get-credentials sgx-autopilot --region asia-southeast1 --project sgx-autopilot-lab

### 5.Deploy the Application
kubectl apply -f manifests/whoami.yaml

---

## Verification Commands
# 1.Cluster details
kubectl cluster-info

kubectl config current-context

# 2.Namespaces and nodes
kubectl get ns

kubectl get nodes

# 3.App deployment
kubectl get deploy,po

kubectl get svc whoami-svc

# 4.Connectivity test
curl http://<EXTERNAL-IP>

# 5.Detailed pod info
kubectl describe pod -l app=whoami

# 6.System-wide health
kubectl get po -A

---

## Monitoring Setup
| Category                | Implementation                                                                                                                                                                                          |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Metrics**             | Used Cloud Monitoring’s *Kubernetes Container* metrics (`CPU usage time`, `Memory usage`). Filtered by `pod_name=whoami` and aggregated by mean.                                                        |
| **Dashboards**          | Created **SGX GKE Monitoring** dashboard with:Combined CPU & Memory line chart **Whoami Uptime Status** scorecard (green/red thresholds) **Pod Phase Status** chart showing pod states.                 |
| **Uptime Checks**       | Configured HTTP uptime check on `whoami-svc` external IP (`http://<EXTERNAL-IP>`). Monitored 1-minute intervals for 200 OK response.                                                                    |
| **Pod Health**          | Used Prometheus metric `prometheus.googleapis.com/kube_pod_status_phase/gauge`, grouped by `phase` (`Running`, `Pending`, `Failed`).                                                                    |
| **Future Enhancements** | Add alerting policy for uptime check failures, 99.9% SLO dashboard, and Workload Identity integration.                                                                                                  |

---

## Teardown
terraform destroy -auto-approve -var="project_id=sgx-autopilot-lab"

---

## Repository Structure
sgx-takehome/
├── terraform/
│   ├── main.tf.json
│   ├── variables.tf.json
│   ├── providers.tf.json
│   ├── versions.tf.json
│   ├── output.tf.json
│   ├── manifests/
│       └── whoami.yaml
├── README.md
└── Evidences/
    ├── Dashboard.png
    ├── CLI kubectl evidences.png
    └── Browser Evidence.png

---

## Summary

Infrastructure as Code – Terraform for full GKE setup

Managed Cluster – Autopilot for simplified scaling

App Deployed – whoami as sample workload

Monitoring – Metrics, uptime, and pod health dashboards

Validation – kubectl and curl confirm functionality


Author: Abel Correya
Date: October 2025
Location: Singapore

