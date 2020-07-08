#!/bin/bash

if ! command -v rename &> /dev/null; then
	echo -e "Can't find rename package.\nexample : apt install rename "
	exit 1
fi

# Variable 
src_dir="${1:-$(dirname $0)}"
count=0
echo -e "organize dirctory is: \n\t $src_dir"

display_usage() {
cat << EOF
./file_organize.sh /source/dir
	or 
./file_organize.sh
Supported media formats : 
	mp3 / flac / opus >> music
	mp4 / mov / 	>> video
	zip / tar / rar >> compression
	jpg / png / gif >> picture
		
EOF
}

find "$src_dir" -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \; 2>/dev/null
sleep 3

find "$src_dir" -name "* *" -type f | rename 's/ /_/g'

fname=$(ls -p "$src_dir"| grep -v / )
sleep 4

mkdir -p "$src_dir/music" "$src_dir/images" "$src_dir/videos" "$src_dir/pdf" "$src_dir/compresion"

readarray name -t <<< $fname

#~ if great then one arguments supplied, display usage 
if [ $# -gt 1 ]; then
	display_usage
	exit 1
fi

#~ display usage
if [[ ( $# == "--help") || $# == "-h" ]]; then
	display_usage
	exit 0
fi

for(( i=0 ; i<${#name[@]} ; i++)); do
	format=${name[$i]: -5}
	if [[ $format == .mp3? ]] || [[ $format == .flac? ]] || [[ $format == opus? ]] ; then 
		mv "$src_dir"/${name[$i]} "$src_dir/music" 2>/dev/null
	elif [[ $format == .jpg? ]] || [[ $format == .png? ]]; then 
		mv "$src_dir"/${name[$i]} "$src_dir/images" 2>/dev/null 
	elif [[ $format == .avi? ]] || [[ $format == .mov? ]] || [[ $format == .mp4? ]]; then
		mv "$src_dir"/${name[$i]} "$src_dir/videos" 2>/dev/null 
	elif [[ $format == .pdf? ]] || [[ $format == epub? ]] || [[ $format == .odt? ]] || [[ $format == docx? ]] ; then
		mv "$src_dir"/${name[$i]} "$src_dir/pdf" 2>/dev/null
	elif [[ $format == .zip? ]] || [[ $format == .rar? ]] || [[ $format == .tar? ]] ; then
		mv "$src_dir"/${name[$i]} "$src_dir/compresion" 2>/dev/null
       	else	
		#TODO: add more format
		count=$((count+1))
	fi

done

echo " total "$count" format undefined in this Directory, be fill free to Developing"
