function [net,info,imdb] = cnn_cifar(train_file, validation_train_file, test_file, validation_test_file,varargin)
%CNN_MNIST  Demonstrates MatConvNet on MNIST

run('/home/anselmo/matconvnet-master-beta23/matlab/vl_setupnn.m') ;

opts.modelType = 'lenet' ;
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.expDir = fullfile('./', 'data', ...
  sprintf('cifar-%s', opts.modelType)) ;
  
[opts, varargin] = vl_argparse(opts, varargin) ;

opts.dataDir = fullfile('data','cifar') ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');
opts.whitenData = true ;
opts.contrastNormalization = true ;
opts.networkType = 'simplenn' ;
opts.train = struct() ;
opts = vl_argparse(opts, varargin) ;
opts.train.gpus = [2];
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;

% --------------------------------------------------------------------
%                                                         Prepare data
% --------------------------------------------------------------------

switch opts.modelType
  case 'lenet'
    net = cnn_cifar_init('networkType', opts.networkType) ;
  case 'nin'
    net = cnn_cifar_init_nin('networkType', opts.networkType) ;
  otherwise
    error('Unknown model type ''%s''.', opts.modelType) ;
end

if exist(opts.imdbPath, 'file')
 imdb = load(opts.imdbPath) ;
else
  imdb=get_imdb(train_file, validation_train_file, test_file, validation_test_file,opts);
end

mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb', '-v7.3') ;

net.meta.classes.name = arrayfun(@(x)sprintf('%d',x),1:25,'UniformOutput',false) ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------

switch opts.networkType
  case 'simplenn', trainfn = @cnn_train ;
  case 'dagnn', trainfn = @cnn_train_dag ;
end

[net, info] = trainfn(net, imdb, getBatch(opts), ...
  'expDir', opts.expDir, ...
  net.meta.trainOpts, ...
  opts.train, ...
  'val', NaN) ; 

% -------------------------------------------------------------------------
function fn = getBatch(opts)
% -------------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

% -------------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end

% -------------------------------------------------------------------------
function inputs = getDagNNBatch(opts, imdb, batch)
% -------------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if rand > 0.5, images=fliplr(images) ; end
if opts.numGpus > 0
  images = gpuArray(images) ;
end
inputs = {'input', images, 'label', labels} ;
