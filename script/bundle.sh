#!/bin/bash

# Copyright (C) 2025 james5635
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

set -e
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."
echo "Start Building Linux bundle..."
cd "$PROJECT_DIR/build"
mkdir -p bundle
mkdir -p bundle/linux
mkdir -p bundle/linux/bin
mkdir -p bundle/linux/lib
mkdir -p bundle/linux/lib/qt
mkdir -p bundle/linux/libexec
cat <<"EOF" >./bundle/linux/bin/calculator
#!/bin/bash

# Copyright (C) 2025 james5635
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

set -e
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR"
export QT_PLUGIN_PATH="$SCRIPT_DIR/../lib/qt/plugins/"
export QT_QPA_PLATFORM_PLUGIN_PATH="$SCRIPT_DIR/../lib/qt/plugins/platforms/"
exec ../libexec/calculator "$@"
EOF
LIB=$(ldd ./calculator | cut -d' ' -f3 | grep -v '\<\(libstdc++.so\|libc.so\|libgcc_s.so\|libm.so\|libpthread.so\|libdl.so\|libasound.so\)')
cp $LIB ./bundle/linux/lib
cp -r /usr/lib/qt/plugins/ ./bundle/linux/lib/qt
cp ./calculator ./bundle/linux/libexec
patchelf --set-rpath '$ORIGIN/../lib' $(echo $LIB | sed -e "s/\/usr\/lib\(64\)\?/.\/bundle\/linux\/lib/g") ./bundle/linux/libexec/calculator
echo "Archiving calculator..."
tar -cJf ./bundle/calculator-linux.tar.xz -C ./bundle/ linux
echo "Calculator Linux bundle created at $PROJECT_DIR/build/bundle/calculator-linux.tar.xz"
echo "Done!"
