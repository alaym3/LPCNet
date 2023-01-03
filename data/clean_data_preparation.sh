#### Make the required directories
rm -rf clean_fullband/Normalized
rm -rf clean_fullband/Volume_regulated
rm -rf clean_fullband/combined.wav
rm -rf clean_combined_16khz.wav
mkdir clean_fullband/Normalized
mkdir clean_fullband/Volume_regulated

#### Normalize audio files
for file in clean_fullband/*.wav;
do
    name=${file##*/}
    base=${name%.txt}
    ffmpeg -i $file -filter:a loudnorm clean_fullband/Normalized/"${base}_norm.wav";
done

#### Divide the loudness by 2
for file in clean_fullband/Normalized/*.wav ;
do
    name=${file##*/}
    base=${name%.txt}
    ffmpeg -i $file -filter:a "volume=0.5" clean_fullband/Volume_regulated/"${base}_reg.wav";
done;

### Combine all audio files into one
sox clean_fullband/Normalized/*.wav clean_fullband/combined.wav

### Change to mono and 16khz
ffmpeg -i clean_fullband/combined.wav -ac 1 -ar 16000 clean_combined_16khz.wav

### Make some space by deleting the temporary files
rm -rf clean_fullband/Normalized
rm -rf clean_fullband/Volume_regulated
rm -rf clean_fullband/combined.wav~/Documents/DLProject/LPCNet/datasets_fullband
gbarlogin2(s221881) $ cat clean_data_preparation.sh
#### Make the required directories
rm -rf clean_fullband/Normalized
rm -rf clean_fullband/Volume_regulated
rm -rf clean_fullband/combined.wav
rm -rf clean_combined_16khz.wav
mkdir clean_fullband/Normalized
mkdir clean_fullband/Volume_regulated

#### Normalize audio files
for file in clean_fullband/*.wav;
do
    name=${file##*/}
    base=${name%.txt}
    ffmpeg -i $file -filter:a loudnorm clean_fullband/Normalized/"${base}_norm.wav";
done

#### Divide the loudness by 2
for file in clean_fullband/Normalized/*.wav ;
do
    name=${file##*/}
    base=${name%.txt}
    ffmpeg -i $file -filter:a "volume=0.5" clean_fullband/Volume_regulated/"${base}_reg.wav";
done;

### Combine all audio files into one
sox clean_fullband/Normalized/*.wav clean_fullband/combined.wav

### Change to mono and 16khz
ffmpeg -i clean_fullband/combined.wav -ac 1 -ar 16000 clean_combined_16khz.wav

### Make some space by deleting the temporary files
rm -rf clean_fullband/Normalized
rm -rf clean_fullband/Volume_regulated
rm -rf clean_fullband/combined.wav~/Documents/DLProject/LPCNet/datasets_fullband
