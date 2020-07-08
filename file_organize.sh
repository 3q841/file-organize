#!/bin/bash

if ! command -v rename &> /dev/null; then
	echo -e "Can't find rename package.\nexample : apt install rename "
	exit 1
fi

display_usage() {
cat << EOF
this script Support Just this file format : 
    .mp3 / .falc : music
    .jpg / .png : image
    .avi / .mov / .mp4 : video
    .pdf / .epub / .odt / .docx : pdf
    .zip / .rar / .tar : compresion
EOF
}

find -name "* *" -type f | rename 's/ /_/g'
fname=$(ls -p | grep -v /  )
count=''
mkdir -p music images videos pdf compresion

readarray name -t <<< $fname

#~ convert UpperCase to LowerCase
ls | sed -n 's/.*/mv "&" $(tr "[A-Z]" "[a-z]" <<< "&")/p' | bash 2>/dev/null

#~ if less then two arguments supplied, display usage 
if [ $# -gt 0 ]; then
	display_usage
	exit 1
fi

#~ check whther user had supplied -h or --help
if [[ ( $# == "--help") || $# == "-h" ]]; then
	display_usage
	exit 0
fi

for(( i=0 ; i<${#name[@]} ; i++)); do
	format=${name[$i]: -5}
	if [[ $format == .mp3? ]] || [[ $format == .flac? ]] ; then 
		mv ${name[$i]} music 2>/dev/null
	elif [[ $format == .jpg? ]] || [[ $format == .png? ]]; then 
		mv ${name[$i]} images 2>/dev/null 
	elif [[ $format == .avi? ]] || [[ $format == .mov ]] || [[ $format == .mp4? ]]; then
		mv ${name[$i]} videos 2>/dev/null 
	elif [[ $format == .pdf? ]] || [[ $format == epub? ]] || [[ $format == .odt? ]] || [[ $format == docx? ]] ; then
		mv ${name[$i]} pdf 2>/dev/null
	elif [[ $format == .zip? ]] || [[ $format == .rar? ]] || [[ $format == .tar? ]] ; then
		mv ${name[$i]} compresion 2>/dev/null
       	else
		sleep 1
		count=$((count+1))
	fi
done

echo " i find $count format's that undefined, if U can Develop, be fill free"
