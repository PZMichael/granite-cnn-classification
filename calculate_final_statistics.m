function [accuracy,precision_vector,recall_vector,f_measure_vector]=calculate_final_statistics(predict, ground_truth, name_file)

	
	confusion=write_confusion_matrix(predict, ground_truth, name_file);
	
	total_matrix=sum(confusion(:));
	total_diagonal=0;
	
	for j=1:size(confusion,1)
		
		total_diagonal=total_diagonal+confusion(j,j);
	end
	
	accuracy=100*(total_diagonal/total_matrix);

	precision_vector=zeros(1,25);
	recall_vector=zeros(1,25);
	f_measure_vector=zeros(1,25);

	for l=1:size(confusion,1)
		precision_vector(l)=confusion(l,l)/sum(confusion(:,l));
		recall_vector(l)=confusion(l,l)/sum(confusion(l,:));
		f_measure_vector(l)=2*(precision_vector(l)*recall_vector(l))/(precision_vector(l)+recall_vector(l));	
	end

function confusion=write_confusion_matrix(predict, groundtruth, name_file)
	
	confusion=zeros(25,25);

	for i=1:size(predict,1)
    		confusion(groundtruth(i,1), predict(i,1))=confusion(groundtruth(i,1), predict(i,1))+1;
	end

	dlmwrite(name_file,confusion);
	

