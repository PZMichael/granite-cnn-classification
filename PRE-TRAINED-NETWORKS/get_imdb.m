% --------------------------------------------------------------------
function imdb = get_imdb(train_file, validation_train_file, test_file, validation_test_file,folder,set_training,set_testing,opts)
% --------------------------------------------------------------------

index_images_train=1;
index_images_test=1;

disp(train_file);

fileTrain = fopen(train_file,'r');
train_filename = textscan(fileTrain,'%s');
fileTrainValidation = fopen(validation_train_file,'r');
train_filename = vertcat(train_filename,textscan(fileTrainValidation,'%s'));

for i=1:size(train_filename{1}(:),1)

	name_image_train=cell2mat(train_filename{1}(i));
   	class=find_class(name_image_train);

    	disp(['Training image '  int2str(i) ' loaded']);
    	im=imread(name_image_train);
	frames=mat2tiles(im,[32,32]);
        count_valid_frames=0;

        for j=1:size(frames,1)*size(frames,2)

	       %Here we limit the number of blocks for training images to be 500 to make 1NN classifier training faster        
	       if (size(frames{j},1)==32) && (size(frames{j},2)==32) && (count_valid_frames<=500)
			im_temp=frames{j};
			x1(:,:,1,index_images_train)=im_temp(:,:,1);
    			x1(:,:,2,index_images_train)=im_temp(:,:,2);
    			x1(:,:,3,index_images_train)=im_temp(:,:,3);
        		y1(index_images_train)=class;
			index_images_train=index_images_train+1;
			count_valid_frames=count_valid_frames+1;
		end		
    	end
end

for i=1:size(train_filename{2}(:),1)

	name_image_train=cell2mat(train_filename{2}(i));
   	class=find_class(name_image_train);

    	disp(['Training image '  int2str(i) ' loaded']);
    	im=imread(name_image_train);	
	frames=mat2tiles(im,[32,32]);
        count_valid_frames=0;
        
     for j=1:size(frames,1)*size(frames,2)
       
	        %Here we limit the number of blocks for training images to be 500 to make 1NN classifier training faster        
		if (size(frames{j},1)==32) && (size(frames{j},2)==32) && (count_valid_frames<=500)
			  		
			im_temp=frames{j};
			x1(:,:,1,index_images_train)=im_temp(:,:,1);
    			x1(:,:,2,index_images_train)=im_temp(:,:,2);
    			x1(:,:,3,index_images_train)=im_temp(:,:,3);
        		y1(index_images_train)=class;
			index_images_train=index_images_train+1;
			count_valid_frames=count_valid_frames+1;
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

    	disp(['Testing image '  int2str(i) ' loaded']);
    	im=imread(name_image_test);
        frames=mat2tiles(im,[32,32]);

        for j=1:size(frames,1)*size(frames,2)
       
		if (size(frames{j},1)==32) && (size(frames{j},2)==32) 		
			im_temp=frames{j};
        		x2(:,:,1,index_images_test)=im_temp(:,:,1);
    			x2(:,:,2,index_images_test)=im_temp(:,:,2);
    			x2(:,:,3,index_images_test)=im_temp(:,:,3);
        		y2(index_images_test)=class;
			index_images_test=index_images_test+1;
		end
    	end
end
 
for i=1:size(test_filename{2}(:),1)

	name_image_test=cell2mat(test_filename{2}(i));
   	class=find_class(name_image_test);

    	disp(['Testing image '  int2str(i) ' loaded']);
    	im=imread(name_image_test);
       	frames=mat2tiles(im,[32,32]);

	%para cada frame 28x28 da imagem, cadastro ele no imdb
        for j=1:size(frames,1)*size(frames,2)
       
		if (size(frames{j},1)==32) && (size(frames{j},2)==32)
  		
			
			im_temp=frames{j};
    			x2(:,:,1,index_images_test)=im_temp(:,:,1);
    			x2(:,:,2,index_images_test)=im_temp(:,:,2);
    			x2(:,:,3,index_images_test)=im_temp(:,:,3);
        		y2(index_images_test)=class;
			index_images_test=index_images_test+1;
            	        count_valid_frames=count_valid_frames+1;


		end
        end
		
	
end

fclose(fileTest);
fclose(fileTestValidation);
set = [ones(1,numel(y1)) 3*ones(1,numel(y2))];
data = single(cat(4, x1, x2));

% remove mean in any case
dataMean = mean(data(:,:,:,set == 1), 4);
dlmwrite(['data/' num2str(folder) '-' num2str(set_training) '-' num2str(set_testing) '-datamean.txt'], dataMean);
%disp(size(data));
%pause;

data = bsxfun(@minus, data, dataMean);
%disp(size(data));
%pause;

imdb.images.data = data ;

%disp(size(imdb.images.data));
%pause;

imdb.images.data_mean = dataMean;
imdb.images.labels = cat(2, y1, y2) ;
imdb.images.set = set ;
imdb.meta.sets = {'train', 'val', 'test'} ;
imdb.meta.classes = arrayfun(@(x)sprintf('%d',x),1:25,'uniformoutput',false) ;
