#!/usr/bin/env bash
update(){
	pushd $1 > /dev/null
	echo updating $1
	git pull --ff-only origin
	popd > /dev/null
}

update camundaServices
update aup
update ams
update dockerstack

