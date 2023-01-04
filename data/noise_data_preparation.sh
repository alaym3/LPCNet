#!/bin/bash

#### Make the required directories
rm -rf noise_fullband/Normalized
rm -rf noise_fullband/Volume_regulated
rm -rf noise_fullband/combined.wav
rm -rf noise_combined_16khz.wav
mkdir noise_fullband/Normalized
mkdir noise_fullband/Volume_regulated

#### Normalize audio files
for file in noise_fullband/*.wav;
do
    name=${file##*/}
    base=${name%.txt}
    ffmpeg -i $file -filter:a loudnorm noise_fullband/Normalized/"${base}_norm.wav";
done;

counter=0
test=0
#### Divide the loudness by 2
for file in noise_fullband/Normalized/*.wav ;
do
    modulus=$(($counter % 100))
    if (($modulus < 5));
    then
        name=${file##*/}
        base=${name%.txt}
        ffmpeg -i $file -filter:a "volume=0.0" noise_fullband/Volume_regulated/"${base}_reg.wav"

    elif (($modulus < 40));
    then
        name=${file##*/}
        base=${name%.txt}
        ffmpeg -i $file -filter:a "volume=0.2" noise_fullband/Volume_regulated/"${base}_reg.wav"
    elif (($modulus < 60));
    then
        name=${file##*/}
        base=${name%.txt}
        ffmpeg -i $file -filter:a "volume=0.4" noise_fullband/Volume_regulated/"${base}_reg.wav"
    elif (($modulus < 85));
    then
       name=${file##*/}
       base=${name%.txt}
       ffmpeg -i $file -filter:a "volume=0.8" noise_fullband/Volume_regulated/"${base}_reg.wav"
    elif (($modulus < 95));
    then
        name=${file##*/}
        base=${name%.txt}
        ffmpeg -i $file -filter:a "volume=1" noise_fullband/Volume_regulated/"${base}_reg.wav"
    else
        name=${file##*/}
        base=${name%.txt}
        ffmpeg -i $file -filter:a "volume=2" noise_fullband/Volume_regulated/"${base}_reg.wav"
    fi
    let counter++
done;

### Combine all audio files into one
sox noise_fullband/Volume_regulated/*.wav noise_fullband/combined.wav

### Change to mono and 16khz
ffmpeg -i noise_fullband/combined.wav -ac 1 -ar 16000 noise_combined_16khz.wav

### Make some space by deleting the temporary files
rm -rf noise_fullband/Normalized
rm -rf noise_fullband/Volume_regulated
rm -rf noise_fullband/combined.wav
