#!/bin/bash

# Monter le système de fichiers
mount --make-shared /

# Démarrer les services (Note : systemctl pourrait ne pas fonctionner comme attendu dans Docker)
systemctl start docker
systemctl start kubelet

# Exécuter le script de déploiement
/bin/bash /etc/kubernetes/deploy-k8s.sh

# Garder le conteneur en fonctionnement (modifiez selon vos besoins)
exec "$@"
