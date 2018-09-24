#!/usr/bin/env bash
pushd $1 > /dev/null
# dependency hash is a mechanism to trigger builds when dependencies did buildOB
dependencyhash=${2:-none} 

currentcommit=`git log -n 1 | grep -o 'commit .*' | xargs -l1 bash -c 'echo $1'`
mustbuild=false
if [[ ! -f lastbuild ]]; then
   echo lastbuild file is not present, forcing build
   mustbuild=true
else
   lastbuildcommit=`cat lastbuild`
   echo comparing $lastbuildcommit and $currentcommit
   if [[ "$lastbuildcommit" != "$currentcommit" ]]; then
      echo lastbuild is not equals to current commit. build is needed
      mustbuild=true
   else
      echo last build commit matches current commit
   fi
fi

# check if dependencies have change
if [[ $dependencyhash != 'none' ]]; then
  if [[ -f lastdependencies ]]; then
    echo lastdependencies found and dependency parameter is set
    lastdependencyhash=`cat lastdependencies`
    if [[ "$dependencyhash" != $lastdependencyhash ]]; then
      mustbuild=true
    else
      echo dependencies were equal
    fi
  else
    echo dependency hash provided but no record of previous value was found, forcing build
    mustbuild=true
  fi
fi

if [[ $mustbuild = 'true' ]]; then
   ./build.sh -B
   if [ $? -eq 0 ]; then
      echo build was successful
      echo $currentcommit > lastbuild
      echo $dependencyhash > lastdependencies
   else
      echo build failed
   fi
else
   echo skip building
fi
