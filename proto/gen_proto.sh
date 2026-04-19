#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."
export PATH="$HOME/.pub-cache/bin:$PATH"

for filename in proto/*.proto; do
    protoc --experimental_allow_proto3_optional --proto_path=proto --dart_out=lib/modules/more/data_and_storage/providers/proto "$filename"
done
