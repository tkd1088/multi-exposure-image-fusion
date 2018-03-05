function weight_out = refine_weight(weight_in)

[H,W,N] = size(weight_in);
weight_out = zeros(H,W,N);

for n = 1 : N
    weight_out(:,:,n) = imgaussfilt(weight_in(:,:,n), 5);
end

