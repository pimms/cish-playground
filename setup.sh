#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

git submodule init

echo Configuring Cish...
cd $DIR/deps/cish
mkdir -p build
cd build
cmake -G Xcode ..

echo Configuring Antlr4 runtime...
cd $DIR/deps/antlr4/runtime/Cpp
mkdir -p build
cd build
cmake -G Xcode ..
