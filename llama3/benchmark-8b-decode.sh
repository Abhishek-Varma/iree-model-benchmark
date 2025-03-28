#!/bin/bash

# Usage: PATH=/path/to/iree/build/tools:$PATH ./benchmark-unet.sh N

set -euo pipefail

if (( $# != 1 && $# != 2 )); then
  echo "usage: $0 <hip-device-id> [<ipra-path>]"
  exit 1
fi

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
readonly WORKING_DIR="${WORKING_DIR:-${SCRIPT_DIR}/tmp}"
readonly PREFIX="${PREFIX:-base}"
readonly IREE_BENCHMARK="$(which iree-benchmark-module)"
readonly HIP_DEVICE="$1"
readonly INPUT_PATH="${INPUT_PATH:-${SCRIPT_DIR}/inputs/8b_fp16/args_bs4_128}"

readonly -a INPUTS=(
  "--input=@${INPUT_PATH}/decode_next_tokens.npy"
  "--input=@${INPUT_PATH}/decode_seq_lens.npy"
  "--input=@${INPUT_PATH}/decode_start_positions.npy"
  "--input=@${INPUT_PATH}/decode_seq_block_ids.npy"
  "--input=@${INPUT_PATH}/decode_cache_state.npy"
)

# IRPA file:
# Size: 16061181952
# md5sum: 8f4685d6799298609152dd509ba32e88
readonly IRPA="${2:-/data/shark/8b_fp16.irpa}"

echo "Using IRPA file:"
stat -c "%y %s %n" "${IRPA}"
# md5sum "${IRPA}"

set -x

"$IREE_BENCHMARK" \
  --device="hip://${HIP_DEVICE}" \
  --device_allocator=caching \
  --hip_use_streams=true \
  --module="${WORKING_DIR}/${PREFIX}.8b_fp16.vmfb" \
  --parameters=model="${IRPA}" \
  --function=decode_bs4  \
  "${INPUTS[@]}" \
  --benchmark_repetitions=3
