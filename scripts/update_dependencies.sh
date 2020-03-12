#!/bin/bash

echo -ne "\033[0;32m"
echo 'Updating bazel dependencies. This will take about five minutes.'
echo -ne "\033[0m"
set -e

BAZEL_DEPS_VERSION="v0.1-1"

if [ "$(uname -s)" == "Linux" ]; then
  BAZEL_DEPS_URL=https://github.com/johnynek/bazel-deps/releases/download/${BAZEL_DEPS_VERSION}/bazel-deps-linux
  BAZEL_DEPS_SHA256=9d80bfbbb59bfdcddad753321e451b3f8152e6190b430f4c0398aa9825f3324c
elif [ "$(uname -s)" == "Darwin" ]; then
  BAZEL_DEPS_URL=https://github.com/johnynek/bazel-deps/releases/download/${BAZEL_DEPS_VERSION}/bazel-deps-macos
  BAZEL_DEPS_SHA256=3ce13fe8308fbc52c7fe2a43363684ad4792298d81045074ddeaeea0544aa63e
else
  "Your platform $(uname -s) is unsupported, sorry"
  exit 1
fi


SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $SCRIPTS_DIR

REPO_ROOT=$(git rev-parse --show-toplevel)

BAZEL_DEPS_PATH="$HOME/.bazel-deps-cache/${BAZEL_DEPS_VERSION}"


if [ ! -f ${BAZEL_DEPS_PATH} ]; then
  ( # Opens a subshell
    set -e
    echo "Fetching bazel deps."
    curl -L -o /tmp/bazel-deps-bin $BAZEL_DEPS_URL

    GENERATED_SHA_256=$(shasum -a 256 /tmp/bazel-deps-bin | awk '{print $1}')

    if [ "$GENERATED_SHA_256" != "$BAZEL_DEPS_SHA256" ]; then
      echo "Sha 256 does not match, expected: $BAZEL_DEPS_SHA256"
      echo "But found $GENERATED_SHA_256"
      echo "Recommend you:  update the sha to the expected"
      echo "and then re-run this script"
      exit 1
    fi

    chmod +x /tmp/bazel-deps-bin
    mv /tmp/bazel-deps-bin ${BAZEL_DEPS_PATH}
  )
fi

cd $REPO_ROOT
set +e
$BAZEL_DEPS_PATH generate -r $REPO_ROOT -s 3rdparty/workspace.bzl -d dependencies.yaml  --target-file 3rdparty/target_file.bzl --disable-3rdparty-in-repo
RET_CODE=$?
set -e

if [ $RET_CODE == 0 ]; then
  echo "Success, going to format files"
else
  echo "Failure, checking out 3rdparty/jvm"
  cd $REPO_ROOT
  git checkout 3rdparty/jvm 3rdparty/workspace.bzl
  exit $RET_CODE
fi

$BAZEL_DEPS_PATH format-deps -d $REPO_ROOT/dependencies.yaml -o

