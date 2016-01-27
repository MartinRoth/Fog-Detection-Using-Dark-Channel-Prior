function [radiance, transmission, trans_est, atmosphere, dark_channel] = dehaze( image, omega, win_size)
%DEHZE Summary of this function goes here
%   Detailed explanation goes here

if ~exist('omega', 'var')
    omega = 0.95;
end

if ~exist('win_size', 'var')
    win_size = 1;
end

[m, n, ~] = size(image);

dark_channel = get_dark_channel(image, win_size);

atmosphere = get_atmosphere(image, dark_channel);

trans_est = get_transmission_estimate(image, atmosphere, omega, win_size);

transmission = imguidedfilter(trans_est,image,...
    'NeighborhoodSize',[40 40],'DegreeOfSmoothing',10^(-2));

radiance = get_radiance(image, transmission, atmosphere);

end