#!/bin/bash
echo "Updating AndroidManifest.xml to minSdkVersion=15"
cd platforms/android
sed -i '' 's/android:minSdkVersion="14"/android:minSdkVersion="15"/' AndroidManifest.xml
cd ../../