#!/usr/bin/env bash

echo ""
echo "Downloading YJsonValidator..."

# Prepare
mkdir -p /var/tmp/YJsonValidator.tmp && cd /var/tmp/YJsonValidator.tmp

echo ""
# Clone from git
git clone https://github.com/yangjunsss/YJsonValidator.git --depth 1 /var/tmp/YJsonValidator.tmp > /dev/null

echo ""
echo "Installing YJsonValidator..."

# Then build
xcodebuild clean > /dev/null
xcodebuild > /dev/null

# Remove tmp files
cd ~
rm -rf /var/tmp/YJsonValidator.tmp

# Done
echo ""
echo "YJsonValidator successfully installed! 🍻 Please restart your Xcode."
echo ""