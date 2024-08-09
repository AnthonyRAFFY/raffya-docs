## Environment variables
    export LB_IP="your_ip" # Example : "192.168.1.27"
    export NFS_IP="x.x.x.x" # Example: "192.168.1.21"
    export CONFIG_PATH="your_config_nfs_path" # Example : "/nfs-data"
    export DATA_PATH="your_data_nfs_path" # Example : "/nfs-data"
    export CONFIG_SC="nfs-ssd"
    export DATA_SC="nfs-hdd"

## NFS
Install both config and data nfs provisioner:

    helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
    helm install nfs-hdd nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server="${NFS_IP}" \
    --set nfs.path="${DATA_PATH}" \
    --set storageClass.name="${DATA_SC}"

    helm install nfs-ssd nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server="${NFS_IP}" \
    --set nfs.path="${CONFIG_PATH}" \
    --set storageClass.name="${CONFIG_SC}"

## ACME
Install the ArgoCD application:

    argocd app create acme --repo git@github.com:AnthonyRAFFY/homelab2.git --path acme --dest-namespace cert-manager --dest-server https://kubernetes.default.svc --directory-recurse

## Storage
Install the ArgoCD application:

    argocd app create pvc --repo git@github.com:AnthonyRAFFY/homelab2.git --path pvc --dest-namespace media --dest-server https://kubernetes.default.svc

## Jellyseerr
Install the ArgoCD application:

    argocd app create jellyseerr --repo git@github.com:AnthonyRAFFY/homelab2.git --path jellyseerr --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"


## QBittorrent
Install the ArgoCD application:

    argocd app create qbittorrent --repo git@github.com:AnthonyRAFFY/homelab2.git --path qbittorrent --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}" --helm-set wg_private_key="private_key_from_conf" --helm-set wg_addresses="adresses_from_conf" --helm-set wg_server_name="se-mma-wg-004" --helm-set wg_port="51815"

## Radarr
Install the ArgoCD application:

    argocd app create radarr --repo git@github.com:AnthonyRAFFY/homelab2.git --path radarr --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"

## Sonarr
Install the ArgoCD application:

    argocd app create sonarr --repo git@github.com:AnthonyRAFFY/homelab2.git --path sonarr --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"

## Prowlarr
Install the ArgoCD application:

    argocd app create prowlarr --repo git@github.com:AnthonyRAFFY/homelab2.git --path prowlarr --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"

## Jellyfin
Install the ArgoCD application:

    argocd app create jellyfin --repo git@github.com:AnthonyRAFFY/homelab2.git --path jellyfin --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"

## Flaresolverr
Install the ArgoCD application:

    argocd app create flaresolverr --repo git@github.com:AnthonyRAFFY/homelab2.git --path flaresolverr --dest-namespace media --dest-server https://kubernetes.default.svc

## Dashboard
Install the ArgoCD application:

    argocd app create dashboard --repo git@github.com:AnthonyRAFFY/homelab2.git --path dashboard --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"

# Joal
Install the ArgoCD application:

    argocd app create joal --repo git@github.com:AnthonyRAFFY/homelab2.git --path joal --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}" --helm-set wg_private_key="private_key_from_conf" --helm-set wg_addresses="adresses_from_conf" --helm-set wg_server_name="se-mma-wg-004" --helm-set wg_port="51815" --helm-set joal_prefix="your_joal_prefix" --helm-set joal_secret_token="your_joal_secret_token"

# Twitchminer
Install the ArgoCD application:

    argocd app create twitchminer --repo git@github.com:AnthonyRAFFY/homelab2.git --path twitchminer --dest-namespace media --dest-server https://kubernetes.default.svc --helm-set lb_ip="${LB_IP}" --helm-set storageClass="${CONFIG_SC}"