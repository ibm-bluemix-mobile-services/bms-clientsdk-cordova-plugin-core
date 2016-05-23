#!/bin/bash
echo "Fetching and building frameworks for ios."
cd platforms/ios
carthage update --no-use-binaries
cd ../../