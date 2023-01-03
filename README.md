# LPCNet

The goal of this project consists in modifying and training the LPCNet model to supress noise. The original LPCNet algorithm, was described in:

- J.-M. Valin, J. Skoglund, [LPCNet: Improving Neural Speech Synthesis Through Linear Prediction](https://jmvalin.ca/papers/lpcnet_icassp2019.pdf), *Proc. International Conference on Acoustics, Speech and Signal Processing (ICASSP)*, arXiv:1810.11846, 2019.
- Source github reopsitory: https://github.com/xiph/LPCNet

# Training data

Suitable training material can be obtained from [Open Speech and Language Resources](https://github.com/microsoft/DNS-Challenge).  See the 
download-dns-challenge-3.sh file for details to choose clean speech and noise training data.

Once the training data is downloaded, place it inside the data folder:
- Create a clean_fullband directory to store the clean speech audio files. 
- Create a noise_fullband directory to store the noise audio files.

# Training a model

1. Prepare the training data:
- Before running the steps bellow, make sure to download and save the training data as instructed in the **Training data** section. 
- In the data directory, run the *clean_data_preparation.sh* file to prepare the clean speech audio data for the training.
- In the data directory, run the *noise_data_preparation.sh* file to prepare the noise audio data for the training. Note: it is possible to modify the repartition of the different SNR level by changing the *volume* parameters.
- In the data directory, run the *final_data_preparation.sh* file to combine the clean speech to the noise.

1. Extract training features for clean and noisy data: in the *TrainingFinal* directory, run *1_extract_training_features.sh* file

1. Set up a Keras system with GPU.

1. Once the features are extracted, train the model by running the following command line:
   ```
   python3 ../training_tf2/train_lpcnet.py data/training_noise_features.f32 data/training_noise_data.s16 data/training_clean_features.f32 data/training_clean_data.s16 model_train_name
   ```

# Run the model

1. Once the model has been trained, build the model by running the *3_build_trained_model.sh* file. It is highly recommended to set the CFLAGS environment variable to enable AVX or NEON *prior* to running this file, otherwise no vectorization will take place and the code will be very slow. On a recent x86 CPU, something like
```
export CFLAGS='-Ofast -g -march=native'
```
should work. On ARM, you can enable Neon with:
```
export CFLAGS='-Ofast -g -mfpu=neon'
```
While not strictly required, the -Ofast flag will help with auto-vectorization, especially for dot products that cannot be optimized without -ffast-math (which -Ofast enables). Additionally, -falign-loops=32 has been shown to help on x86.

2. You can test the capabilities of LPCNet using the lpcnet\_demo application. To encode a file:
```
./lpcnet_demo -encode input.pcm compressed.bin
```
where input.pcm is a 16-bit (machine endian) PCM file sampled at 16 kHz. The raw compressed data (no header)
is written to compressed.bin and consists of 8 bytes per 40-ms packet.

To decode:
```
./lpcnet_demo -decode compressed.bin output.pcm
```
where output.pcm is also 16-bit, 16 kHz PCM.

Alternatively, you can run the uncompressed analysis/synthesis using -features
instead of -encode and -synthesis instead of -decode.
The same functionality is available in the form of a library. See include/lpcnet.h for the API.

To try packet loss concealment (PLC), you first need a PLC model, which you can get with:
```
./download_model.sh plc-3b1eab4
```
or (for the PLC challenge submission):
```
./download_model.sh plc_challenge
```
PLC can be tested with:
```
./lpcnet_demo -plc_file noncausal_dc error_pattern.txt input.pcm output.pcm
```
where error_pattern.txt is a text file with one entry per 20-ms packet, with 1 meaning "packet lost" and 0 meaning "packet not lost".
noncausal_dc is the non-causal (5-ms look-ahead) with special handling for DC offsets. It's also possible to use "noncausal", "causal",
or "causal_dc".


# Note

Source: [LPCNet Github demo](https://github.com/xiph/LPCNet)

The BSD licensed software is written in C and Python/Keras. For training, a GTX 1080 Ti or better is recommended.

This software is an open source starting point for LPCNet/WaveRNN-based speech synthesis and coding.
