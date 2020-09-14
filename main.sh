#!/bin/bash
#
# Script to transcode multi video & audio formats into prores & pcm for import to Davinci Resolve
#
indir=~/Videos/pre_transcode_in/ #Input directory for pre-transcode video & audio files
outdir=~/Videos/transcoded_prores_pcm/ #Output directory for transcoded prores/pcm video & audio files
#
[ ! -d "$outdir" ] && mkdir "$outdir" #Check if output directory exists, if not, create it.
#
cd -- "$indir"
ls | while read upName; do loName=`echo "${upName}" | tr '[:upper:]' '[:lower:]'`; mv "$upName" "$loName"; done #convert input dir files to lowercase

# Start of section for video container transcoding

for cont in mkv m4v mp4 avi wmv flv mov # list of video container filename suffixes to check for files
do
for file in *.$cont; do
if [ -e "$file" ]; then
echo
echo "****** Starting transcode of $file to prores/pcm .mov ******"
echo
ffmpeg -i "$file" -c:v prores -profile:v 3 -c:a pcm_s24le "$outdir""${file%.*}".mov;
echo
echo "****** End of $file ******"
echo
fi
done
done

# Start of section for audio file transcoding

for codec in flac mp3 aac wma ogg oga mogg raw # list of audio codec filename suffixes to check for files
do
for file in *.$codec; do
if [ -e "$file" ]; then
echo
echo "****** Starting transcode of $file to pcm .wav ******"
echo
ffmpeg -i "$file" -c:a pcm_s24le "$outdir""${file%.*}".wav;
echo
echo "****** End of $file ******"
echo
fi
done
done