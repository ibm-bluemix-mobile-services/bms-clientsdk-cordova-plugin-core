#!/bin/bash
echo "Fetching and building frameworks for ios."
cd platforms/ios
carthage update --no-use-binaries
cd ../../

# plutil -convert xml1 -o platforms/ios/*proj/project.pbxproj platforms/ios/*proj/project.pbxproj
