#!/bin/bash

wd=$(pwd)
cd /Library/LaunchDaemons
for filename in $(ls .); do
	if [ -L $filename ] && [ ! -e $filename ]; then
		launchctl unload -w $filename
		rm $filename
	fi
done

cd $wd
