#!/usr/bin/env bash

set -e

ORIGINAL_PWD="$PWD"

TMPDIR="${TMPDIR:-/tmp}"
TARGET_TMP_DIR="$TMPDIR$RND_UID"
mkdir -p $TARGET_TMP_DIR

cd $TARGET_TMP_DIR
git clone https://github.com/protocolbuffers/protobuf.git gprotobuf

cd gprotobuf
git checkout $PROTOBUF_SHA
git reset --hard
rm -rf .git

$ORIGINAL_PWD/bazel build @com_google_protobuf//:protoc

cp bazel-bin/external/com_google_protobuf/protoc $ORIGINAL_PWD/protoc
