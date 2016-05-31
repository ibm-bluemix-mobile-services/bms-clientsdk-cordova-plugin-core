#!/bin/bash
echo "Updating AndroidManifest.xml to minSdkVersion=15"
cd platforms/android
sed -i 's/minSdkVersion="14"/minSdkVersion="15"/' platforms/android/AndroidManifest.xml
cd ../../