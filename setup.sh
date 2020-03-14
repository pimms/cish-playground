#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

git submodule init

cd $DIR/deps/cish
mkdir -p build
cd build
cmake -G Xcode ..
