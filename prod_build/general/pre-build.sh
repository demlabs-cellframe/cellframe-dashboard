#!/bin/bash

extract_version_number() {

IFS=" "

local VERSION_STRING=$VERSION_FORMAT
for entry in $VERSION_ENTRIES; do
	VERSION_STRING=$(echo $VERSION_STRING | sed "s/$entry/$( cat $VERSION_FILE | grep ^$entry | sed 's/ //g' | cut -d '=' -f2 )/") #Replacing templates with numbers
#	echo $VERSION_STRING
done
echo -e "$VERSION_STRING"

}

extract_gitlog_text() {

borders=$( git log | grep -n 'commit\|Date' | head -n 3 | tail -n 2 | cut -d ':' -f1)
upb=$(echo $borders | cut -d ' ' -f1)
dwnb=$(echo $borders | cut -d ' ' -f2)
text=$(git log | head -n $( expr $dwnb - 2 ) | tail -n $( expr $dwnb - $upb - 3 ) )
echo "$text"

}

export_variables() {

IFS=$'\n'
for variable in $(cat $1); do
	echo "$variable"
	export $(echo "$variable" | sed 's/\"//g')
done

}

unexport_variables() {

IFS=$'\n'
for variable in $(cat $1); do
	echo "$variable"
	export -n $(echo $variable | cut -d '=' -f1)
done

}
