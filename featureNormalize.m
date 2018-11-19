function [X_norm, mu, sigma] = featureNormalize(X)
%FEATURENORMALIZE Normalizes the features in X 
%   FEATURENORMALIZE(X) returns a normalized version of X where
%   the mean value of each feature is 0 and the standard deviation
%   is 1. This is often a good preprocessing step to do when
%   working with learning algorithms.
X = X';
mu = mean(X);
X_norm = bsxfun(@minus, X, mu);%bsxfun两个数组间元素逐个计算:@minus 减 @rdivide 左除 

sigma = std(X);%算出X_norm的标准偏差
X_norm = bsxfun(@rdivide, X_norm, sigma);
X_norm = X_norm';

mu = mu';
sigma = sigma';
% ============================================================

end
