#!/bin/bash

rm -rf artifacts/* src/JabbR/wwwroot/lib/*

if ! type dnvm > /dev/null 2>&1; then
    curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | sh && source ~/.dnx/dnvm/dnvm.sh
fi
export DNX_UNSTABLE_FEED=https://www.myget.org/F/aspnetrelease/api/v2
dnvm install latest -u
dnu restore src/JabbR

rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

dnu publish src/JabbR --no-source --out artifacts/build/jabbr --runtime active 2>&1 | tee buildlog
grep "Build succeeded" buildlog
