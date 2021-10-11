#!/bin/bash
set -e -o pipefail
set -x

export GOPATH="${GOBUILD:-/tmp/build-golang}"
SELF=$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || stat -f "${BASH_SOURCE[0]}")
cd "$(dirname "${SELF}")" #just in case ...
GOMODULE=$(go list -m -mod=readonly)

if [ ! -h "$GOPATH/src/$GOMODULE" ]; then
    mkdir -p "$GOPATH/src/$(dirname "$GOMODULE")"
    ln -s "$PWD" "$GOPATH/src/$GOMODULE"
fi

go get -d -u github.com/golang/dep
cd "$GOPATH/src/$GOMODULE"
exec dep ensure -update
