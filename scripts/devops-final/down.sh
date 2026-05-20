#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

TAG_ARG=""

while getopts ":t:h" opt; do
  case "${opt}" in
    t)
      TAG_ARG="${OPTARG}"
      ;;
    h)
      echo "Usage: bash scripts/devops-final/down.sh"
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

if [[ -n "${TAG_ARG}" ]]; then
  echo "[INFO] Tag parameter is ignored during shutdown: ${TAG_ARG}"
fi

cd "${REPO_ROOT}"
docker compose -f docker-compose.devops.yml down
