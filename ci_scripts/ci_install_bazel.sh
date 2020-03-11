set -e
cd $GITHUB_WORKSPACE

cp ci_scripts/bootstrapping_bazel bazel

./bazel


