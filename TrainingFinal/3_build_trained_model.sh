### Extract the model files nnet_data.h and nnet_data.c
python3 ../training_tf2/dump_lpcnet.py ./Model02/model_train_002_384_78.h5

### Move the files to suorce folder
mv nnet_data.h ../src/
mv nnet_data.c ../src/

### Build again
cd ..
make
