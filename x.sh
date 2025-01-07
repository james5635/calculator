#!/bin/bash
set -e
build() {
  mkdir -p build
  cd build/
  qmake6 ../calculator.pro
  # qmake ../calculator.pro
  make
}
clean() {
  rm -rf ./build
}
run() {
  build
  ./calculator
}

"$@"
