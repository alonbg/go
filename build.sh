#!/bin/bash
set -e -o pipefail
set -x
shopt -s extglob

export LC_ALL=C
export GOPATH=/tmp/build-golang
SELF="$(readlink "${BASH_SOURCE[0]}" || stat -f "${BASH_SOURCE[0]}")"
cd "$(dirname "$SELF")"
MODULE=$(grep module go.mod | cut -d" " -f2)

if [ ! -h "$GOPATH/src/$MODULE" ]; then
    mkdir -p "$GOPATH/src/$(dirname "$MODULE")"
    ln -s "$PWD" "$GOPATH/src/$MODULE"
fi

go get -d -u github.com/golang/dep
cd "$GOPATH/src/$MODULE"
exec dep ensure -update
