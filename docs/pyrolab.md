# Helm installation
    curl -sSL -O https://get.helm.sh/helm-v3.14.4-linux-amd64.tar.gz
    tar -zxvf helm-v3.14.4-linux-amd64.tar.gz
    sudo install -m 555 linux-amd64/helm /usr/local/bin/helm
    rm -r linux-amd64 helm-v3.14.4-linux-amd64.tar.gz

# Traefik
Traefik is already installed by default with K3S

# Cert-manager installation
#### Helm repository
    helm repo add jetstack https://charts.jetstack.io --force-update
    helm repo update
#### Install CRDs without helm (recommanded in the official documentation)
    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.4/cert-manager.crds.yaml
#### Helm chart
    helm install \
    cert-manager jetstack/cert-manager \
    --namespace cert-manager \
    --create-namespace \
    --version v1.14.4 \
    --set prometheus.enabled=false
# Self-signed certificate authority
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: pyrolab-selfsigned-issuer
    spec:
      selfSigned: {}
    ---
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
      name: pyrolab-selfsigned-cert
      namespace: cert-manager
    spec:
      isCA: true
      commonName: pyrolab-selfsigned-cert
      secretName: pyrolab-selfsigned-tls
      privateKey:
        algorithm: ECDSA
        size: 256
      issuerRef:
        name: pyrolab-selfsigned-issuer
        kind: ClusterIssuer
        group: cert-manager.io
      subject:
        organizations:
          - Pyrolab inc.
        organizationalUnits:
          - Pyrolab
Export the base64 encoded ca.crt from "pyrolab-selfsigned-cert", decode it and import it in your OS.
# ArgoCD
#### Installation
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

    # Get the initial password
    argocd admin initial-password -n argocd
    # Once you have the password, delete the argocd-initial-admin-secret secret

### Certificate
    apiVersion: cert-manager.io/v1
    kind: Certificate
    metadata:
        name: argocd-cert
        namespace: argocd
    spec:
        dnsNames:
            - argocd.192.168.1.27.nip.io
        secretName: argocd-tls
        issuerRef:
            name: pyrolab-issuer
            kind: ClusterIssuer
### Disable TLS termination
By default Argo-CD handles TLS termination itself and always redirects HTTP requests to HTTPS. Combine that with an ingress controller that also handles TLS termination and always communicates with the backend service with HTTP and you get Argo-CD's server always responding with a redirects to HTTPS.
    
    kubectl edit configmaps -n argocd argocd-cmd-params-cm

    # Add
    data:
        server.insecure: "true"
then run the command
    
    kubectl edit configmaps -n argocd argocd-cmd-params-cm

#### Ingress route creation

    apiVersion: traefik.containo.us/v1alpha1
    kind: IngressRoute
    metadata:
    name: argocd-server
    namespace: argocd
    spec:
    entryPoints:
        - websecure
    routes:
        - kind: Rule
        match: Host(`argocd.192.168.1.27.nip.io`)
        priority: 10
        services:
            - name: argocd-server
            port: 80
        - kind: Rule
        match: Host(`argocd.192.168.1.27.nip.io`) && Headers(`Content-Type`, `application/grpc`)
        priority: 11
        services:
            - name: argocd-server
            port: 80
            scheme: h2c
    tls:
        certResolver: default
#### Login
Connect to the UI dashboard and change the default admin password, then connect the argocd CLI

    argocd login argocd.192.168.1.27.nip.io
