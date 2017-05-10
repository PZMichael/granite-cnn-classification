function [train_data, test_data]=features_vector_generator(imdb,net)

	disp('gerando feature vectors');

%agora vou gerar as features
    net.layers = net.layers(1:12);
    features_train=zeros(1,64);

   %features de treino pego ao aplicar somente as imagens de treino no simplenn
   %já estou pegando DIRETO do IMDB, então elas já estão subtraídas da média!!!!!!
   train_images=single(imdb.images.data(:,:,:,imdb.images.set==1));
   batch_size=100;
   index=1;
   
   if(mod(size(train_images,4),batch_size)==0)
   	max_iterations=size(train_images,4)/batch_size;
   else
        max_iterations=(size(train_images,4)/batch_size)+1;
   end

for i=1:max_iterations
        if(i==1)
        	batch_train_images=train_images(:,:,:,index:batch_size);
        	index=index+batch_size;
        	res_train=vl_simplenn(net,batch_train_images)';   
        	features_train=vertcat(features_train,squeeze(res_train(12).x)');
	else
                %chegou ao fim
                if(index+batch_size-1>size(train_images,4))
                	batch_train_images=train_images(:,:,:,index:end);
        	        res_train=vl_simplenn(net,batch_train_images)';   
        	        features_train=vertcat(features_train,squeeze(res_train(12).x)');
                
                else

			batch_train_images=train_images(:,:,:,index:index+batch_size-1);
        		index=index+batch_size;
        		res_train=vl_simplenn(net,batch_train_images)';   
        		features_train=vertcat(features_train,squeeze(res_train(12).x)');
                end  
	end
   end

   %pego as classes do imdb cujo tipo (set) é de teste   
   classes_train=imdb.images.labels(imdb.images.set==1)';
        train_data=horzcat(classes_train,features_train(2:end,:)); 


   
   clearvars -except net imdb batch_size train_data
       features_test=zeros(1,64);
   

   %features de teste pego ao aplicar somente as imagens de teste no simplenn
   test_images=single(imdb.images.data(:,:,:,imdb.images.set==3));
   index=1;

   if(mod(size(test_images,4),batch_size)==0)
   	max_iterations=size(test_images,4)/batch_size;
   else
        max_iterations=(size(test_images,4)/batch_size)+1;
   end
   
   for i=1:max_iterations
        %disp(i);

        if(i==1)
        	batch_test_images=test_images(:,:,:,index:batch_size);
        	index=index+batch_size;
        	res_test=vl_simplenn(net,batch_test_images)';   
        	features_test=vertcat(features_test,squeeze(res_test(12).x)');
	else

                if(index+batch_size-1>size(test_images,4))
                	batch_test_images=test_images(:,:,:,index:end);
        	        res_test=vl_simplenn(net,batch_test_images)';   
        	        features_test=vertcat(features_test,squeeze(res_test(12).x)');
                
                else

			batch_test_images=test_images(:,:,:,index:index+batch_size-1);
        		index=index+batch_size;
        		res_test=vl_simplenn(net,batch_test_images)';   
        		features_test=vertcat(features_test,squeeze(res_test(12).x)');
                end  
	end
   end

  classes_test=imdb.images.labels(imdb.images.set==3)';
   test_data=horzcat(classes_test,features_test(2:end,:));
      clearvars -except imdb net train_data test_data
   
