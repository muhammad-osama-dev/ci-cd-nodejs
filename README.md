# CI/CD Node.js Sample Application 🚀

This repository demonstrates a complete CI/CD pipeline for a Node.js application using:

- **GitHub Actions** for CI/CD  
- **Docker** for containerization  
- **GCP Artifact Registry** for image storage  
- **GKE (Google Kubernetes Engine)** for deployment  
- **Terraform** (IaC) for provisioning infrastructure – see [infrastructure repo](https://github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment) (`feature/scale-down` branch)  
- **Kustomize** for Kubernetes configuration overlays  

---

## ✅ Requirements

To run and deploy this application successfully, make sure the following are set up:


### 🔐 Granting Push Access to Artifact Registry

To push Docker images to Google Artifact Registry from GitHub Actions, follow these steps:

1. **Create a Service Account**

    ```bash
    gcloud config set project YOUR_PROJECT_ID

    gcloud iam service-accounts create artifact-registry-pusher \
    --description="Service account for pushing images to Artifact Registry" \
    --display-name="Artifact Registry Pusher"

    gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:artifact-registry-pusher@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/artifactregistry.writer"
    
    gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
        --member="serviceAccount:artifact-registry-pusher@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
        --role="roles/storage.admin"

    gcloud iam service-accounts keys create ~/artifact-registry-pusher-key.json \
        act-registry-pusher@YOUR_PROJECT_ID.iam.gserviceaccount.com

2. **Add the Key to GitHub Repository Secrets**

    Go to your GitHub repository → Settings → Secrets and Variables → Actions → Add New Repository Secret:

    - Add secret `GCP_SA_KEY`  
    - Value: base64-encoded content of `artifact-registry-pusher-key.json`

---

## 🔧 Infrastructure Setup

Infrastructure is deployed using Terraform. See the [infrastructure repo](https://github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment), `feature/scale-down` branch.


## 📦 Features

- ✅ Lint and test Node.js code on push and pull request
- 🐳 Build and push Docker image to GCP Artifact Registry
- 🚀 Deploy to a private GKE cluster using a GitHub self-hosted runner that's the bastion for the private GKE
- 🔧 Kustomize used to manage Kubernetes deployment configs

---

## 📁 Project Structure

- `.github/workflows/`  
  Contains GitHub Actions CI/CD workflow definitions.

- `k8s/`  
  Kubernetes manifests and Kustomize configs  
  - `deployment.yaml`
  - `service.yaml`
  - `namespace.yaml`
  - `kustomization.yaml`  # Kustomize config combining above resources and managing image tag

- `Dockerfile`  
  Docker build instructions for the app.

- `README.md`  
  Project documentation (you’re reading it!).

---

## 🛠️ Setup Instructions

### 1. Fork the Repo

git clone https://github.com/your-username/ci-cd-nodejs.git
cd ci-cd-nodejs

---

### 2. Configure Environment Variables

Update the repository secrets or environment variables under GitHub repository → Settings → Secrets and variables:

| Name                | Description                              |
|---------------------|------------------------------------------|
| PROJECT_ID          | GCP project ID                           |
| REGION              | GCP region (e.g., us-central1)           |
| REPOSITORY          | GCP Artifact Registry name               |
| IMAGE_NAME          | Docker image name                        |
| GKE_CLUSTER_NAME    | GKE cluster name                         |
| GKE_ZONE            | GKE cluster zone                         |
| GCP_SA_KEY          | Base64-encoded GCP service account key (use the key.json we created before in the requriment section)  |


### 3. Deploy the Infrastructure

follow steps here: [infrastructure repo](https://github.com/muhammad-osama-dev/gcp-nodejs-mongodb-deployment):

---

### 4. GitHub Actions CI/CD

CI/CD pipeline triggers on every push and PR to main:

- Lint: Runs eslint on code
- Build: Builds Docker image and tags with commit SHA
- Push: Pushes image to GCP Artifact Registry
- Deploy: Applies Kubernetes manifests via Kustomize

---

### 5. Access the App

After deployment, GitHub Actions will log the external IP of the Kubernetes LoadBalancer service:

```bash
External IP found: http://<your-external-ip>
```

You can verify the app is running by curling the external IP:

```bash
curl http://<your-external-ip>
```

You should receive the following response:

```bash
Hello Node!
```

---

## 📋 Assumptions

- Required GCP APIs (GKE, Artifact Registry, etc.) are enabled.

---

## 🔍 Future Improvements

- Add Helm for Kubernetes packaging

---

## 📄 License

MIT License.

---

## 🙋‍♂️ Author

Muhammad Osama – https://github.com/muhammad-osama-dev