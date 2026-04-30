#!/bin/bash
set -eu

# This does not work with a symlink to this script
# SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# See https://stackoverflow.com/a/246128/24637657
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  [[ $SOURCE != /* ]] && SOURCE=$SCRIPT_DIR/$SOURCE
done
SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
REPO_ROOT=${REPO_ROOT:-$SCRIPT_DIR/..}

echo "Serving documentation"
${CONTAINER_RUNTIME:-docker} run --rm -t \
  -p 8000:8000 \
  --volume /etc/passwd:/etc/passwd:ro --volume /etc/group:/etc/group:ro \
  --user "$(id -u)":"$(id -g)" \
  -v "${REPO_ROOT}":/docs squidfunk/mkdocs-material serve -a 0.0.0.0:8000
