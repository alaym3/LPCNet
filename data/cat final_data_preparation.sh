### Delete existing output files with same name
rm -rf training_clean_and_noisy_audio.wav

### Overlay the noise to the speech
ffmpeg -i clean_combined_16khz.wav -filter_complex "amovie=noise_combined_16khz.wav:loop=999[s];[0][s]amix=duration=shortest" training_clean_and_noisy_audio.wav~/Documents/DLProject/LPCNet/datasets_fullband
