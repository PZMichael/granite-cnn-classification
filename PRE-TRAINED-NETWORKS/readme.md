This folder has a code that basically does the same thing of the code present on the root folder. However, here the models are loaded (there is no CNN training from scratch like what the code in root folder does). This can save you memory, but will spend a higher running time.

The code does the following:
1. Load CNN model and mean value of training CNN tiles
2. for each training and testing image do
  2.1 subdivide it into 32x32 blocks
  3. For each block do
    3.1 subtract it from the mean block present in CNN training
    3.2 apply the resulting block in the CNN, extracting 64-D vectors
4. if training, train a 1-nn classifier with all vectors from training images. 
5. If testing, classify its blocks feature vectors and perform a majority voting on blocks classification to decide image's class. 

Please let me know if you have problems with data or code. My contacts are: anselmo.ferreira@gmail.com or anselmo@szu.edu.cn
