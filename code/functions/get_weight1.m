function weight = get_weight1(img_seq_lum)

[H,W,N] = size(img_seq_lum);
weight = zeros(H,W,N);

% compute mean value of non-exposed intensity region
means = mean(mean(img_seq_lum));
means = reshape(means, N,1);

% compute sigma value of non-exposed intensity region
sigmas = zeros(N,1);
sigmas(1) = (means(2) - means(1))/2;
for n = 2 : N-1
    sigmas(n) = (means(n+1) - means(n-1))/4;
end
sigmas(N) = (means(N) - means(N-1))/2;
sigmas = sigmas*3;

% compute weight map of each image in luminance image sequence
for n = 1 : N
    weight(:,:,n) = exp(-0.5*(img_seq_lum(:,:,n) - (1-means(n))).^2/sigmas(n)/sigmas(n));
end
