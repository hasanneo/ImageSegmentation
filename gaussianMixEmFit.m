function [m, covar, w, z] = gaussianMixEmFit(X, nKernels)
% Maximum-likelihood fit of data 'X' on a gaussian mixture model,
% made up by 'nKernels' number of kernels. All variates data vectors
% (X's columns) are assumed to be observed.
%
% Example:
%       gaussianMixEmFit(randn(2, 100));
%   will fit 100 random bivariate data on a 4-kernel (default) gaussian
%   mixture.
%       gaussianMixEmFit(X, 11);
%   will fit data from columns of matrix 'X' on a 11-kernel gaussian
%   mixture.
%
% Arguments:
% X         -   Input. Each column is one datum.
% nKernels  -   Number of kernels on mixture model.
% m         -   EM means; i-th column represents mean of the i-th kernel.
% covar     -   EM covariances; i-th matrix represents covariance of the
%                   i-th kernel. (ie (:,:,i) ).
% w         -   EM kernel weigths.
%
%   Hasan Awad june 2020
d = size(X, 1);% number of rows (features)
N = size(X, 2);% number of cols (pixels)
if nargin < 2
    nKernels = 4;
end
%initiate params
[m w junk covar] = deterministicKmeans(X(:,1:N), nKernels);

clear allDataMean;
clear allDataCov;
% End Init
%
% Main EM loop
%
iteration = 0;
llChangeRatio = 0;
disp('EM iteration  Likelihood     Average Logl      LhoodIncrease');
disp('------------------------------------------------------------');
while 1
    % E-step
    for i = 1:nKernels
        z(i, :) = w(i) * gaussianValue(X, m(:,i), covar(:,:,i));
    end
    % Before 'z' is correctly normalized, use it to compute the likelihood:
    likelihood = sum(log(sum(z, 1)+eps));
    z = z ./ (ones(nKernels, 1) * (sum(z, 1)+eps));%normalize z
    if iteration ~= 0
        llChangeRatio = (likelihood - prev) / abs(prev);%change in liklihood 
    end
    disp(sprintf('%3d           %3.2f         %2.5f      %2.5f%%', ...
            iteration, likelihood, likelihood/N, llChangeRatio*100));
    if iteration > 1 && llChangeRatio < 1e-3 %% end repeat as requested
        break;
    end
    iteration = iteration + 1;
    % M-step
    w = sum(z, 2)' / N;% update weight
    for i = 1:nKernels
        if(sum(z(i, :)) > 0) %To catch empty clusters
            m(:, i) = (X * z(i, :)') / sum(z(i, :));% update mean vectors
        end
        %update covariance
        newCovar = inv(sum(z(i, :))) * ( ...
            (X - m(:, i)*ones(1,N))* ...
            sparse(1:N, 1:N, z(i,:), N, N) * ...
            (X - m(:, i)*ones(1,N))' );
        newCovar = newCovar + eps*eye(d);
        if rcond(newCovar) > 1e3 * eps
            covar(:, :, i) = newCovar;
        end
        clear newCovar;
    end
    prev = likelihood;
end
return;