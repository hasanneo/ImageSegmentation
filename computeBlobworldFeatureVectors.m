function y = computeBlobworldFeatureVectors(inimage);
% Gives a (:,:,6) matrix of L, a, b, polarity, anisotropy, contrast features.
% Input must be (:,:,3), an r g b feature matrix.
%
% y = computeBlobworldFeatureVectors(inimage)
%
% 
%
% 
%   Hasan Awad june 2020
labnosmooth = rgb2lab(inimage);
scales = scaleSelection(labnosmooth(:,:,1));
[polarity, l1, l2] = computePolarity(labnosmooth(:,:,1), scales);
if sum(sum(l1<0)) ~= 0 && sum(sum(l2<0)) ~= 0
    disp('EM: Warning! Eigenvalues should be positive!!');
end
anisotropy = 1 - (l2./(l1+eps));
contrast = 2 * sqrt(l1+l2);
feat(:,:,1) = double(smoothUsingVariantScale(labnosmooth(:,:,1), scales));
feat(:,:,2) = double(smoothUsingVariantScale(labnosmooth(:,:,2), scales));
feat(:,:,3) = double(smoothUsingVariantScale(labnosmooth(:,:,3), scales));
feat(:,:,4) = polarity;
feat(:,:,5) = anisotropy;
feat(:,:,6) = contrast;
%image(anisotropy);
y = feat;
return;