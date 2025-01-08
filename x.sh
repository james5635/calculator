#!/bin/bash

# Copyright (C) 2025 james5635
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

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
