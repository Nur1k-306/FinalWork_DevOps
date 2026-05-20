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
      echo "Usage: bash scripts/devops-final/deploy.sh -t <tag>"
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

echo "[INFO] Deploying docker-compose.devops.yml with tag: ${TAG}"

cd "${REPO_ROOT}"
TAG="${TAG}" docker compose -f docker-compose.devops.yml up -d
docker compose -f docker-compose.devops.yml ps
