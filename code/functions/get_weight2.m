function weight = get_weight2(img_seq_lum)

[H,W,N] = size(img_seq_lum);
img_hists = zeros(256,N);

for n = 1 : N
    img = uint8(255*img_seq_lum(:,:,n));
    [img_hists(:,n),~] = imhist(img); 
end

img_hists =img_hists./repmat(sum(img_hists,1),[256 1]);

gradient_for_ij = zeros(H,W,N);
for n = 1 : N
    for i = 1 : H
        for j = 1 : W
            idx = ceil(255*img_seq_lum(i,j,n))+1;
            gradient_for_ij(i,j,n) = 1/(img_hists(idx,n)+eps);
        end
    end
end

gradient_for_ij_max = sum(gradient_for_ij,3) + 1e-12;
weight = gradient_for_ij./repmat(gradient_for_ij_max,[1 1 N]);