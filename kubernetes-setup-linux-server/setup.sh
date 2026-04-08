#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io
curl -sfL https://k3s.io | sh -
echo "Kurulum tamamlandı, Docker ve K8s hazır!"
