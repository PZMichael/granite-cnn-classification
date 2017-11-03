%You must change this path to where your MATCONVNET installation is
%run('/home/anselmo/Desktop/matconvnet-1.0-beta23/matlab/vl_setupnn.m') ;
disp('Starting Experiments...');

[acc1,precision1,recall1,fmeasure1]=main(1,1,2);
[acc2,precision2,recall2,fmeasure2]=main(1,2,1);
[acc3,precision3,recall3,fmeasure3]=main(2,1,2);
[acc4,precision4,recall4,fmeasure4]=main(2,2,1);
[acc5,precision5,recall5,fmeasure5]=main(3,1,2);
[acc6,precision6,recall6,fmeasure6]=main(3,2,1);
[acc7,precision7,recall7,fmeasure7]=main(4,1,2);
[acc8,precision8,recall8,fmeasure8]=main(4,2,1);
[acc9,precision9,recall9,fmeasure9]=main(5,1,2);
[acc10,precision10,recall10,fmeasure10]=main(5,2,1);

disp('Experiments Finished. Reporting Results.');
disp(['Mean Accuracy: ' num2str(mean(horzcat(acc1,acc2,acc3,acc4,acc5,acc6,acc7,acc8,acc9,acc10)))]);
disp(['Mean Precisiom: ' num2str(mean(horzcat(precision1,precision2,precision3,precision4,precision5,precision6,precision7,precision8,precision9,precision10)))]);
disp(['Mean Recall: ' num2str(mean(horzcat(recall1,recall2,recall3,recall4,recall5,recall6,recall7,recall8,recall9,recall10)))]);
disp(['Mean F-Measure: ' num2str(mean(horzcat(fmeasure1,fmeasure2,fmeasure3,fmeasure4,fmeasure5,fmeasure6,fmeasure7,fmeasure8,fmeasure9,fmeasure10)))]);
