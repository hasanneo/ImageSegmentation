function y = convertJxN(A)
% Convert a MxNxJ matrix to JxMN. The conversion is done columnwise.
% Can handle matrices of higher dimensionality, eg 
% can convert MxNxPxJ to JxMNP.
% Example:
%       convertJxN(imread('lenna.jpg'))
%   will give a 3xMN matrix, w/ each column the rgb intensities of a
%   single pixel.
t2 = shiftdim(A, max(size(size(A))) - 1);
y = shiftdim(t2(:,:),+1)';
return;