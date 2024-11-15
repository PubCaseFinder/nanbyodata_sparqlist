#!/bin/bash

set -u

###
# 本番環境の repository の中で、開発環境のエンドポイントを参照していそうなファイルを出力する　
###

script_dir=$(readlink -f "$(dirname "$0")")
PRODUCT_REPOSITORY_DIR=$script_dir/../repository
find "$PRODUCT_REPOSITORY_DIR" -type f -name "*.md" | while read -r source_file; do
    filename=$(basename "$source_file")
    result=$(grep '/sparql' $source_file | grep  'dev')
    if [ -n "$result" ]; then
        echo "開発環境用Endpointが書かれている可能性があります. $filename '$result'"
    fi
done
