#!/usr/bin/env bash
newartifactid=$2
echo new artifact id is $newartifactid

if [[ -f lastartifactid ]]; then 
  echo lastartifactid file exists, checking content
  lastartifactid=`cat lastartifactid`
  if [[ "$lastartifactid" = "$newartifactid" ]]; then
    echo content is equal
    exit
  fi
fi
echo publishing
DIRNAME=WARS-`date +%Y-%m-%d_%H%M`
mkdir /c/WARS/$DIRNAME
cp $1 /c/WARS/$DIRNAME/

## deploying
tempdir=`mktemp -d`
cp $1 "$tempdir"
pushd "$tempdir" > /dev/null
tar xvf suite-distribution-generic-1.0-SNAPSHOT-bundle.tar
./install.sh -n master -p 8081 -g 15432
popd > /dev/null

echo $newartifactid > lastartifactid
docker restart httpfront_front_1
echo done at `date -Iseconds`

