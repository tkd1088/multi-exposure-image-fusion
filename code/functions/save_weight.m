function save_weight(weight, path)

[~,~,N] = size(weight);


weight = weight + 1e-12;
weight = weight./repmat(sum(weight,3),[1 1 N]);

for n = 1 : N
    imwrite(weight(:,:,n), [path, '/w', num2str(n), '.png']);
end
