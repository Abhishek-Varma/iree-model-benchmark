#!/bin/bash

# Usage: PATH=/path/to/iree/build/tools:$PATH ./compile-8b-fp8.sh --chip <hip-target-chip> [extra flags]

if (( $# < 1 )); then
  echo "usage: $0 --chip <hip-target-chip> [--data-tiling]"
  exit 1
fi

# Default values
CHIP=""
DATA_TILING=0

# Parse named arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --chip)
      CHIP="$2"
      shift 2
      ;;
    --data-tiling)
      DATA_TILING=1
      shift 1
      ;;
    --help)
      echo "Usage: $0 [--chip <value>] [--data-tiling]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

set -euo pipefail

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
readonly IREE_COMPILE="$(which iree-compile)"
readonly WORKING_DIR="${WORKING_DIR:-${SCRIPT_DIR}/tmp}"
readonly PREFIX="${PREFIX:-base}"

set -x

"${SCRIPT_DIR}/compile-8b-base.sh" "$IREE_COMPILE" "$CHIP" "$DATA_TILING" \
  "${SCRIPT_DIR}/base_ir/8b_fp8.mlir" \
  -o "${WORKING_DIR}/${PREFIX}.8b_fp8.vmfb" \
  "$@"
