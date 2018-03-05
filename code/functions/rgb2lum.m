function img_seq_lum = rgb2lum(img_seq_rgb)

[H,W,C,N] = size(img_seq_rgb);

if (C ~= 3)
    error('image sequence must be 3-channel');
end

img_seq_lum = zeros(H,W,N);



for n = 1 : N
    img_seq_ycbcr = rgb2ycbcr(img_seq_rgb(:,:,:,n));
    img_seq_lum(:,:,n) = img_seq_ycbcr(:,:,1);
end