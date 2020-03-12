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

git rev-parse HEAD

rm -rf .git

cp $ORIGINAL_PWD/user.bazelrc .bazelrc
$ORIGINAL_PWD/bazel build @com_google_protobuf//:protoc

cp bazel-bin/protoc $ORIGINAL_PWD/protoc
