function y = scaleSelection(inimage);
% Select 'proper' smoothing scale (see Blobworld)
% using polarity measure.
% 'inimage' contains L* values.
% Output contains standard deviation values,
%  corresponding to proper gaussian convolution kernels
%  for each pixel.
%
% y = scaleSelection(inimage)
% Hasan Awad june 2020
threshold = 0.02; %As specified in Blobworld paper
i=1;
for k = 1:8
    scale = (k-1)/2;
    [tpl, junk, junk2] = computePolarity(inimage, scale);
    polarity(:,:,i)=convolution2D(tpl,2*scale);%stack polarity( p~_sigma_k)
    i=i+1;
end
polarityGrad = diff(polarity, 1, 3);
%last part of finding scale
% stopMap and stopIndex contain info about the correct stopping scale.
stopMap = abs(polarityGrad) <= threshold;
stopMap(:,:,end+1) = 1;
for m = 1:size(stopMap,3)
    % The second addent is a trick to disregard zeros on the 'min'
    % operation later.
    stopMap2(:,:,m) = stopMap(:,:,m)*m + (stopMap(:,:,m)==0)*(size(stopMap,3)+1);
end
[temp, stopIndex] = min(stopMap2, [], 3);
stopIndex = (stopIndex-1)/2;

y = stopIndex;

return;

