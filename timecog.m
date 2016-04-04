function [ cengrav ] = timecog( inputmat )
%timecog computes the centers of gravity for all the time dashs
%   [ Ccengrav ] = timecog( inputmat )
%   Each row is a different animal.

% remove NaNs
inputmat(isnan(inputmat)) = 0 ;

% compute masses
masses = inputmat(:,2:2:end) - inputmat(:,1:2:end-1);

% compute distances
distances = (inputmat(:,2:2:end) + inputmat(:,1:2:end-1))/2;

% compute centers of gravity
cengrav = sum(masses .* distances, 2) ./ sum(masses,2);


end

