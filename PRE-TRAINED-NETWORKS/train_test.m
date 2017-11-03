function [acc,precision_vector,recall_vector,fmeasure_vector]=train_test(train_file,test_file, folder,set_training,set_testing)

	system(['mkdir data/' num2str(folder) '-' num2str(set_training) ]);

	train_data=dlmread(train_file);
	test_data=dlmread(test_file);

	train_vec=train_data(:,2:end);
	train_class=train_data(:,1);
	test_vec=test_data(:,2:end);
	test_class=test_data(:,1);
	
	disp('training classifier for 1 nearest neighbors');		
	B = fitcknn(train_vec, train_class);
	B.NumNeighbors = 1;
	
	disp('testing classifier');
	numExemplars = size(test_vec,1);
    chunkSize = 1000;
    k=1:chunkSize:numExemplars;
			
    output=zeros(1,1);

    for l=1:length(k)-1
    	index1 = k(l);
    	index2 = k(l+1)-1;
    	fprintf('classifying exemplars %d to %d\n', index1, index2 );
    	chunk = test_vec(index1:index2,:);
    	temp=predict(B,chunk);
        output=vertcat(output,temp);
    end
	%last bit of data
	chunk = test_vec(k(end):numExemplars,:);
	temp=predict(B,chunk);
	output=vertcat(output,temp);
	output=output(2:end);
		
	num_blocks_per_image=ones(1,500)*2116;  
                 
	output2=voting(output,num_blocks_per_image);
	ground_truth=voting(test_class,num_blocks_per_image);

	[acc,precision_vector,recall_vector,fmeasure_vector]=calculate_final_statistics(output2', ground_truth', [num2str(folder) '-' num2str(set_training) '-' num2str(set_testing)  '-confusion_matrix.txt']);
	
	disp(['Accuracy after majority voting of image blocks:' num2str(acc) '%']);

	clearvars B temp

	
end
   

