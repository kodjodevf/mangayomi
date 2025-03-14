#!/bin/bash
for filename in proto/*.proto; do
    protoc --dart_out=../lib/modules/more/data_and_storage/providers/proto "$filename"
done
