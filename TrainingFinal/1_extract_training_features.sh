### Get training files and change file extension
mv data/clean_combined_16khz.wav data/clean_combined_16khz.s16
mv data/training_clean_and_noisy_audio.wav data/training_clean_and_noisy_audio.s16

rm -rf data/training_clean_features.f32
rm -rf data/training_clean_data.s16
rm -rf data/training_noise_features.f32
rm -rf data/training_noise_data.s16

### Extract training features for clean and noisy data
../dump_data -train data/clean_combined_16khz.s16 data/training_clean_features.f32 data/training_clean_data.s16
../dump_data -train data/training_clean_and_noisy_audio.s16 data/training_noise_features.f32 data/training_noise_data.s16
