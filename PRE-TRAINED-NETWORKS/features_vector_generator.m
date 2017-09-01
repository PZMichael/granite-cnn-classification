function [train_data, test_data]=features_vector_generator(folder,set_training,set_testing,train_file, validation_train_file, test_file, validation_test_file)

	disp('loading data');
   	mean_image=dlmread(['models/' num2str(folder) '-' num2str(set_training) '-' num2str(set_testing) '-datamean.txt']);
   	load(['models/' num2str(folder) '-' num2str(set_training) '-' num2str(set_testing) '-net-epoch-142.mat']);
	
        %agora vou gerar as features
   	net.layers = net.layers(1:12);
   	features_train=zeros(1,65);
   	features_test=zeros(1,65);


	fileTrain = fopen(train_file,'r');
	train_filename = textscan(fileTrain,'%s');
	fileTrainValidation = fopen(validation_train_file,'r');
	train_filename = vertcat(train_filename,textscan(fileTrainValidation,'%s'));

	for i=1:size(train_filename{1}(:),1)

		name_image_train=cell2mat(train_filename{1}(i));
   		class=find_class(name_image_train);

    		disp(['Training image '  int2str(i) ' ready for feature vectors extracting']);
    		im=imread(name_image_train);
		frames=mat2tiles(im,[32,32]);
        	count_valid_frames=0;

        	for j=1:size(frames,1)*size(frames,2)
	       		%Here we limit the number of blocks for training images to be 500 to make 1NN classifier training faster        
	       		if (size(frames{j},1)==32) && (size(frames{j},2)==32) && (count_valid_frames<=500)
				im_temp=bsxfun(@minus, double(frames{j}), reshape(mean_image,[32,32,3]));
				res_train=vl_simplenn(net,single(im_temp))';
				features_train=vertcat(features_train,horzcat(class,squeeze(res_train(12).x)'));
			end		
    		end	
	end

	for i=1:size(train_filename{2}(:),1)

		name_image_train=cell2mat(train_filename{2}(i));
   		class=find_class(name_image_train);

    		disp(['Training image '  int2str(250+i) ' ready for feature vectors extracting']);
    		im=imread(name_image_train);	
		frames=mat2tiles(im,[32,32]);
        	count_valid_frames=0;
        
     		for j=1:size(frames,1)*size(frames,2)
       
	        	%Here we limit the number of blocks for training images to be 500 to make 1NN classifier training faster        
			if (size(frames{j},1)==32) && (size(frames{j},2)==32) && (count_valid_frames<=500)
			  		
				im_temp=bsxfun(@minus, double(frames{j}), reshape(mean_image,[32,32,3]));
				res_train=vl_simplenn(net,single(im_temp))';
				features_train=vertcat(features_train,horzcat(class,squeeze(res_train(12).x)'));
				
			end
        	end
	end

fclose(fileTrain);
fclose(fileTrainValidation);

fileTest = fopen(test_file,'r');
test_filename = textscan(fileTest,'%s');

fileTestValidation = fopen(validation_test_file,'r');
test_filename = vertcat(test_filename,textscan(fileTestValidation,'%s'));

		for i=1:size(test_filename{1}(:),1)

		name_image_test=cell2mat(test_filename{1}(i));
   		class=find_class(name_image_test);

    		disp(['Testing image '  int2str(i) ' ready for feature vectors extracting']);
    		im=imread(name_image_test);
		frames=mat2tiles(im,[32,32]);
        	count_valid_frames=0;

        	for j=1:size(frames,1)*size(frames,2)
	       		%Here we limit the number of blocks for testing images to be 500 to make 1NN classifier testing faster        
	       		if (size(frames{j},1)==32) && (size(frames{j},2)==32) && (count_valid_frames<=500)
				im_temp=bsxfun(@minus, double(frames{j}), reshape(mean_image,[32,32,3]));
				res_test=vl_simplenn(net,single(im_temp))';
				features_test=vertcat(features_test,horzcat(class,squeeze(res_test(12).x)'));
			end		
    		end	
	end

		for i=1:size(test_filename{2}(:),1)

		name_image_test=cell2mat(test_filename{2}(i));
   		class=find_class(name_image_test);

    		disp(['Testing image '  int2str(250+i) 'ready for feature vectors extracting']);
    		im=imread(name_image_test);
		frames=mat2tiles(im,[32,32]);
        	count_valid_frames=0;

        	for j=1:size(frames,1)*size(frames,2)
	       		%Here we limit the number of blocks for testing images to be 500 to make 1NN classifier testing faster        
	       		if (size(frames{j},1)==32) && (size(frames{j},2)==32) && (count_valid_frames<=500)
				im_temp=bsxfun(@minus, double(frames{j}), reshape(mean_image,[32,32,3]));
				res_test=vl_simplenn(net,single(im_temp))';
				features_test=vertcat(features_test,horzcat(class,squeeze(res_test(12).x)'));
			end		
    		end	
	end

train_data=features_train(2:end,:);
test_data=features_test(2:end,:);
disp(size(train_data));
disp(size(test_data));

