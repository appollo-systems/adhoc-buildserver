#!/usr/bin/env bash
wait_time() {
   for ((t=$1;t>0;t--))
   do 
     echo -ne Press any key to continue. Will automatically continue in $t seconds.'\r' 
     read -s -n1 -t 1 keypress
     if [[ $? -eq 0 ]]; then
        echo key pressed
	return;
     fi
   done
}

while true; do
  cat <<MESSAGE
****************************************************
UPDATING ALL PROJECTS
****************************************************
MESSAGE
  ./update-all.sh
  ./pbuild-all.sh
  ./publish-artifact.sh dockerstack/suite-distribution-generic/target/suite-distribution-generic-1.0-SNAPSHOT-bundle.tar `cat dockerstack/lastbuild dockerstack/lastdependencies | md5sum -t`
  wait_time 7200
done
