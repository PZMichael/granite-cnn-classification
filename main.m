function [acc,precision,recall,fmeasure]= main(folder,set_training,set_testing)

	train_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_training) '.txt'];
	validation_train_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_training) '-validation.txt'];
	test_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_testing) '.txt'];
	validation_test_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_testing) '-validation.txt'];
	train_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_training) '.txt'];
	validation_train_file=['AUX/5X2_DATA/' num2str(folder) '/split' num2str(set_training) '-validation.txt'];
	test_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_testing) '.txt'];
	validation_test_file=['AUX_FOLDER/5X2_DATA/' num2str(folder) '/split' num2str(set_testing) '-validation.txt'];
	
	%train the network, finding the filter weights 
	[net,info,imdb]=cnn_cifar(train_file, validation_train_file, test_file, validation_test_file);
	
	%use the network as feature extractor
    	[train_data, validation_data]=features_vector_generator(imdb,net);

	%save the feature vectors	
	dlmwrite(['data/' num2str(folder) '-' num2str(set_training)  '-train.txt'], train_data);
	dlmwrite(['data/' num2str(folder) '-' num2str(set_testing)  '-test.txt'], validation_data);

	%train and test the 32x32 blocks. The classification of images will be done after majority voting of blocks
	%the classification used here is the 1NN classifier
	[acc,precision,recall,fmeasure]=train_test(['data/' num2str(folder) '-' num2str(set_training)  '-train.txt'], ['data/' num2str(folder) '-' num2str(set_testing)  '-test.txt'], folder,set_training,set_testing);

	%write results
	dlmwrite(['fmeasures.txt'], fmeasure, '-append');
	dlmwrite(['precisions.txt'], precision, '-append');
	dlmwrite(['recalls.txt'], recall, '-append');
	dlmwrite(['accuracias.txt'], acc, '-append');
	dlmwrite(['accuracies.txt'], acc, '-append'); 
	system('rm -rf data/cifar-lenet/*.mat');


