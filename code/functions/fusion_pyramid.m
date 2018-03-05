function result = fusion_pyramid(imgs, weights, lev)

%   lev         input differently exposed image sequence (double, [H,W,C,N])
%
%   weights     input weight map for each image (double, [H,W,N])
%
%   result      output fused image


[H,W,C,N] = size(imgs);

if(~exist('lev', 'var')),
    lev = floor(log(min(H,W)) / log(2));
end

addpath('functions/pyramid_decomposition');



% normalize weight
weights = weights + 1e-12; %avoids division by zero
weights = weights./repmat(sum(weights,3),[1 1 N]);

% create empty pyramid
pyr = gaussian_pyramid(zeros(H,W,C),lev);
% nlev = length(pyr);

% multiresolution blending
for n = 1 : N
    % construct pyramid from each input image
	pyrW = gaussian_pyramid(weights(:,:,n),lev);
    pyrI = laplacian_pyramid(imgs(:,:,:,n),lev);
    
    % blend
    for l = 1:lev
        w = repmat(pyrW{l},[1 1 C]);
        pyr{l} = pyr{l} + w.*pyrI{l};
    end
end

% reconstruct
result = reconstruct_laplacian_pyramid(pyr);

