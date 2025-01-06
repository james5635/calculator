#!/bin/bash
build() {
  mkdir -p build
  cd build/
  qmake ../calculator.pro
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
