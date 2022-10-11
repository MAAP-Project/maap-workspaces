#!/bin/bash

set -e

readarray -d '' metas < <(find devfiles -name 'meta.yaml' -print0)
N=0

echo [

for meta in "${metas[@]}"; do
    if [ $N -gt 0 ]
    then
      echo ,
    fi
    N=$((N+1))

    META_DIR=$(dirname "${meta}")
    yq r --prettyPrint -j ${META_DIR}/meta.yaml
done

echo ]
