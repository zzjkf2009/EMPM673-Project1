%This function is to compute meam and variance of given data
% Model: 1D Gaussian Model
%Input: data is Color Sample data from 'colorDistribution.m'
%Output: mean and variance 

function [mu sigma]=estimate(data)

mu=mean(double(data));
sigma=cov(double(data));

end
