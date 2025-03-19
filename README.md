# IREE Model Benchmarks

A set of scripts and tools to benchmark popular ML models with IREE, optimized
with compiler development workflows in mind. The goal is to prioritize the ease
of set up over completeness or production readiness, while providing a good
enough proxy for real-world deployment.

## Models

All the models below were exported using [SHARK AI](https://github.com/nod-ai/shark-ai).

The currently supported models are:
* SDXL (fp16, int8, fp8)
* Llama3 8b
