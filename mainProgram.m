%driver program for the approach
%   
%   Hasan Awad june 2020
original_image=imread('zebra.jpg');
lab_mat=rgb2lab(original_image);
features=computeBlobworldFeatureVectors(original_image);
 X = double(convertJxN(features));
 X = X([1 2 3 6 5 4], :);%l*,a*,b*,contrast,anistropy,polarity
 imageSize = [size(original_image, 1) size(original_image, 2)];
 fprintf('buildSegmentation: _Using %d kernel Gaussian MM_\n', 3)
 [mean_vectors, covariance_mats, weights, z] = gaussianMixEmFit(X, 3);
 em_result=reshape(choose_max,imageSize(1),imageSize(2));
 %mixture weights represent the probability that Xi belongs to the k-th mixture component.
 l_scales=scaleSelection(lab_mat(:,:,1));
 
[polarity, l1, l2] = computePolarity(lab_mat(:,:,1), l_scales);
anisotropy = 1 - (l2./(l1+eps));
contrast = 2 * sqrt(l1+l2);
anisotropy8 = uint8(255 * mat2gray(anisotropy));
polarity8=uint8(255 * mat2gray(polarity));
contrast8=uint8(255 * mat2gray(contrast));
%%%%%
l_smoothed=uint8(255 * mat2gray(smoothUsingVariantScale(lab_mat(:,:,1),l_scales)));
a_smoothed=uint8(255 * mat2gray(smoothUsingVariantScale(lab_mat(:,:,2),l_scales)));
b_smoothed=uint8(255 * mat2gray(smoothUsingVariantScale(lab_mat(:,:,3),l_scales)));
%%%smooth original
red=uint8(255 * mat2gray(smoothUsingVariantScale(double(original_image(:,:,1)),l_scales)));
green=uint8(255 * mat2gray(smoothUsingVariantScale(double(original_image(:,:,2)),l_scales)));
blue=uint8(255 * mat2gray(smoothUsingVariantScale(double(original_image(:,:,3)),l_scales)));
smoothed_image(:,:,1)=red;
smoothed_image(:,:,2)=green;
smoothed_image(:,:,3)=blue;
%%last part
[val, group_vec] = max(z, [], 1);
group_mat=reshape(group_vec,imageSize(1),imageSize(2));
mask = boundarymask(group_mat);
%trying to show BlobWorld representation
%calculate what is 1% of the image
one_percent=(imageSize(1)*imageSize(2))*0.01;
IL = bwlabel(mask);
R = regionprops(mask,'Area');%take boundaries
ind = find([R.Area] >= one_percent);
Iout = ismember(IL,ind);%blob image representation
%final result
figure;
subplot(4,3,1);
imshow(original_image);
subplot(4,3,2);
imshow(smoothed_image);
%L*a*b*
subplot(4,3,4);
imshow(l_smoothed);
subplot(4,3,5);
imshow(a_smoothed);
subplot(4,3,6);
imshow(b_smoothed);
%textures
subplot(4,3,7);
imshow(anisotropy);
subplot(4,3,8);
imshow(polarity);
subplot(4,3,9);
imshow(contrast);
%EM RESULTS
subplot(4,3,10);
imshow(em_result);
%segmentation
subplot(4,3,11);
imshow(Iout);
subplot(4,3,12);
imshow(labeloverlay(original_image,mask,'Transparency',0));