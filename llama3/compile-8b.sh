#!/bin/bash

# Usage: PATH=/path/to/iree/build/tools:$PATH ./compile-8b.sh <target-chip> [extra flags]

set -euo pipefail

if (( $# < 1 )); then
  echo "usage: $0 <hip-target-chip>"
  exit 1
fi

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
readonly IREE_COMPILE="$(which iree-compile)"
readonly CHIP="$1"
shift 1

readonly WORKING_DIR="${WORKING_DIR:-${SCRIPT_DIR}}"

set -x

"${SCRIPT_DIR}/compile-8b-base.sh" "$IREE_COMPILE" "$CHIP" \
  "${SCRIPT_DIR}/base_ir/8b_fp16_nondecomposed.mlir" \
  -o "${WORKING_DIR}/tmp/8b_fp16_nondecomposed.vmfb" \
  "$@"
