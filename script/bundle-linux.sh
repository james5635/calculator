#!/bin/bash

# Copyright (C) 2025 james5635
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

set -e
if [ -f /etc/os-release ]; then
  # freedesktop.org and systemd
  . /etc/os-release
  OS=$NAME
  VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
  # linuxbase.org
  OS=$(lsb_release -si)
  VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
  # For some versions of Debian/Ubuntu without lsb_release command
  . /etc/lsb-release
  OS=$DISTRIB_ID
  VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
  # Older Debian/Ubuntu/etc.
  OS=Debian
  VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
  # Older SuSE/etc.
  ...
elif [ -f /etc/redhat-release ]; then
  # Older Red Hat, CentOS, etc.
  ...
else
  # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
  OS=$(uname -s)
  VER=$(uname -r)
fi
if [ "$OS" != "Arch Linux" -a "$OS" != "Ubuntu" ]; then
  echo "This script is only for Arch Linux and Ubuntu"
  exit 0
fi
[ "$OS" = "Ubuntu" ] && sudo >/dev/null 2>&1 || apt update && apt install -y sudo
[ "$OS" = "Ubuntu" ] && sudo apt update &&
  sudo apt install -y qtcreator qtbase5-dev qt5-qmake cmake \
    libgl1-mesa-dev libxkbcommon-x11-0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libxcb-xinerama0 libzstd-dev \
    patchelf tar xz-utils build-essential

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
PROJECT_DIR="$SCRIPT_DIR/.."

cd "$PROJECT_DIR"
echo "Building On $OS $VER"
echo "Start Building Linux bundle..."
mkdir -p build
cd build/
qmake ../calculator.pro
make
mkdir -p bundle
mkdir -p bundle/linux
mkdir -p bundle/linux/bin
mkdir -p bundle/linux/lib
mkdir -p bundle/linux/lib/qt
mkdir -p bundle/linux/libexec
read -r -d '' VAR <<"EOF" || :
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
echo "making executable script..."
echo "$VAR" >./bundle/linux/bin/calculator

LIB=$(ldd ./calculator | cut -d' ' -f3 | grep -v '\<\(libstdc++.so\|libc.so\|libgcc_s.so\|libm.so\|libpthread.so\|libdl.so\|libasound.so\)')
echo $LIB
cp $LIB ./bundle/linux/lib
[ "$OS" = "Arch Linux" ] && cp -r /usr/lib/qt/plugins/ ./bundle/linux/lib/qt
[ "$OS" = "Ubuntu" ] && cp -r /usr/lib/x86_64-linux-gnu/qt5/plugins/ ./bundle/linux/lib/qt
cp ./calculator ./bundle/linux/libexec
[ "$OS" = "Arch Linux" ] && patchelf --set-rpath '$ORIGIN/../lib' $(echo $LIB | sed -e "s/\/usr\/lib\(64\)\?/.\/bundle\/linux\/lib/g") ./bundle/linux/libexec/calculator
[ "$OS" = "Ubuntu" ] && sudo patchelf --set-rpath '$ORIGIN/../lib' $(echo "$LIB" | cut -d'/' -f4 | sed -e "s/\(.\+\)/.\/bundle\/linux\/lib\/\1/g") ./bundle/linux/libexec/calculator
echo "Archiving calculator..."
tar -cJf ./bundle/calculator-linux.tar.xz -C ./bundle/ linux
echo "Calculator Linux bundle created at $PROJECT_DIR/build/bundle/calculator-linux.tar.xz"
echo "Done!"
