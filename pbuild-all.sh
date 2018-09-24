#!/usr/bin/env bash
./pbuild.sh camundaServices
#./pbuild.sh aup
./pbuild.sh ams
# force the building of dockerstack by removing the lastbuild file
./pbuild.sh dockerstack `cat ams/lastbuild aup/lastbuild | md5sum.exe -t`
