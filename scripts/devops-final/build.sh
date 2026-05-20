#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

TAG="latest"
TAG_EXPLICITLY_SET="false"

while getopts ":t:h" opt; do
  case "${opt}" in
    t)
      TAG="${OPTARG}"
      TAG_EXPLICITLY_SET="true"
      ;;
    h)
      echo "Usage: bash scripts/devops-final/build.sh -t <tag>"
      exit 0
      ;;
    \?)
      echo "[ERROR] Unknown option: -${OPTARG}" >&2
      exit 1
      ;;
    :)
      echo "[ERROR] Option -${OPTARG} requires a value." >&2
      exit 1
      ;;
  esac
done

if [[ "${TAG_EXPLICITLY_SET}" != "true" ]]; then
  echo "[WARN] Tag was not provided. Using default tag: latest"
fi

echo "[INFO] Building Docker images with tag: ${TAG}"

SERVICES=(
  api-gateway
  user-service
  device-service
  booking-service
  payment-service
  wash-session-service
  notification-service
  analytics-service
)

echo "[INFO] Building frontend image smart-laundry/frontend:${TAG}"
docker build \
  -f "${REPO_ROOT}/frontend/Dockerfile.devops" \
  -t "smart-laundry/frontend:${TAG}" \
  "${REPO_ROOT}/frontend"

for service in "${SERVICES[@]}"; do
  echo "[INFO] Building backend image smart-laundry/${service}:${TAG}"
  docker build \
    -f "${REPO_ROOT}/Dockerfile.service.devops" \
    --build-arg "SERVICE=${service}" \
    -t "smart-laundry/${service}:${TAG}" \
    "${REPO_ROOT}"
done

echo "[INFO] Build completed successfully."
