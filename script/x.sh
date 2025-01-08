#!/bin/bash

# Copyright (C) 2025 james5635
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

set -e
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/../"
build() {
    cd "$PROJECT_DIR"
    mkdir -p build
    cd build/
    # qmake ../calculator.pro
    qmake ../calculator.pro
    make
}
clean() {
    cd "$PROJECT_DIR"
    rm -rf ./build
}
run() {
    build
    ./calculator
}

"$@"
