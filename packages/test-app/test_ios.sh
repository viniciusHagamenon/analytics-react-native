#!/bin/bash

set -e

cfg=""

pushd project/ios
    if [[ $COCOAPODS == "yes" ]]; then
        cp ../../Podfile .
        yarn react-native link
        pod install
        cat ../requires.js >> ../App.tsx
        cfg="cocoapods"
    else
        yarn remove $(cd ../../../integrations/build && echo @segment/*)
        yarn add @segment/analytics-ios@github:segmentio/analytics-ios
        yarn react-native link
        cfg="vanilla"
    fi
popd

yarn detox build --configuration ios-$cfg
yarn detox test --configuration ios-$cfg --loglevel trace
