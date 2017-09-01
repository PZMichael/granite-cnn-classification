# granite-cnn-classification

This is the source code related to the paper "Convolutional Neural Network approaches to granite tiles classification" published by Expert Systems and Applications.

If you use this code in your research please don't forget to cite our paper:

Anselmo Ferreira, Gilson Giraldi. Convolutional Neural Network approaches to granite tiles classification. 
Expert Systems with Applications, Volume 84, 30 October 2017, Pages 1-11.

In bibtex you can use 

@article{Ferreira20171,
title = "Convolutional Neural Network approaches to granite tiles classification ",
journal = "Expert Systems with Applications",
volume = "84",
pages = "1 - 11",
year = "2017"
}

basically, what you need to do is running demo_cifar.m and see the magic happening. In this code we perform a 5x2 cross validation experiment to 
validate our algorithm. The CIFAR-based CNN is firstly trained by recognizing 32x32 granite blocks from training data and then it is used as feature extractor 
to train and test a 1NN classifier. For each experiment, we use 500 images from 25 granite classes to train the classifier and the remaining
images to test the classifier. The images classification is performed after majority voting of their small blocks classification. The metrics reported are metrics calculated after 10 rounds of experiments.

You need to configure two things before running the source code:

1- You need to install matconvnet. After installed you must change line 4 of cnn_cifar.m, informing where your compiled matconvnet library is. 
The matconvnet library can be downloaded at http://www.vlfeat.org/matconvnet/

2- You must download the dataset used. We used the dataset from the following website http://dismac.dii.unipg.it/mm/ver_2_0/index.html. 
Please create a subfolder called DATASET in the AUX folder and paste the folders 00..10 from this dataset there.

If you have any questions about the source code, don't hesitate to contact me. My e-mail is anselmo.ferreira@gmail.com

Have fun!
