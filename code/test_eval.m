clear all;
close all;

image_names = cell(17,1);
Q = zeros(10,1);
image_names{1} = 'Balloons';
% image_names{2} = 'BelgiumHouse';
% image_names{3} = 'Cadik';
% image_names{4} = 'Candle';
image_names{2} = 'Cave';
image_names{3} = 'ChineseGarden';
image_names{4} = 'Farmhouse';
% image_names{8} = 'House';
% image_names{9} = 'Kluki';
image_names{5} = 'Lamp';
image_names{6} = 'Landscape';
% image_names{12} = 'LightHouse';
image_names{7} = 'Madison';
% image_names{14} = 'Memorial';
image_names{8} = 'Office';
image_names{9} = 'Tower';
image_names{10} = 'Venice';
%% add path of a folder including support functions
addpath('functions');

%% read multi-exposed rgb image sequence (scaling to [0,1])
T = 0;
for i = 1 : 1
    image_name = image_names{i};
    imgs_rgb = load_images(['G:/dataset/HDR/MEFDatabase/source_image_sequences/', image_name],1);
    imgs_rgb = imgs_rgb/255.0;
    [H,W,C,N] = size(imgs_rgb);
tic;
    %% compute luminance image of rgb image sequence
    imgs_lum = rgb2lum(imgs_rgb);
%     imwrite(imgs_lum(:,:,1), 'G:/dataset/HDR/MEFDatabase/result/Tower/y1.png');
%     imwrite(imgs_lum(:,:,2), 'G:/dataset/HDR/MEFDatabase/result/Tower/y2.png');
%     imwrite(imgs_lum(:,:,3), 'G:/dataset/HDR/MEFDatabase/result/Tower/y3.png');

    %% compute weight1 using luminance distribution
    w1 = get_weight1b(imgs_lum);
%     imwrite(w1(:,:,1), 'G:/dataset/HDR/MEFDatabase/result/Tower/ww1_1.png');
%     imwrite(w1(:,:,2), 'G:/dataset/HDR/MEFDatabase/result/Tower/ww1_2.png');
%     imwrite(w1(:,:,3), 'G:/dataset/HDR/MEFDatabase/result/Tower/ww1_3.png');

    %% compute weight2 using luminance gradient
    delta = 50;
    w2 = get_weight3(imgs_lum, delta);
%     imwrite(w2(:,:,1), 'G:/dataset/HDR/MEFDatabase/result/Tower/ww2_1.png');
%     imwrite(w2(:,:,2), 'G:/dataset/HDR/MEFDatabase/result/Tower/ww2_2.png');
%     imwrite(w2(:,:,3), 'G:/dataset/HDR/MEFDatabase/result/Tower/ww2_3.png');


    %% corporate weight1 & weight2 and refine weight with wlsFilter
    alpha = 1;
    beta = 1;
    w = (w1.^alpha).*(w2.^beta);

    w = refine_weight(w);

    %% save weight images (optional)
%     want_to_save_weight = 1;
%     if (want_to_save_weight)
%         save_weight(w, ['G:/dataset/HDR/MEFDatabase/result/', image_name]);
%     end

    %% fuse images using pyramid decomposition
    lev = 7;
    img_result = fusion_pyramid(imgs_rgb, w, lev);
    T = T + toc;

    %% show and save result image (optional)
%     figure();
%     imshow(img_result);
    want_to_save_result = 1;
    if (want_to_save_result)
        imwrite(img_result, ['G:/dataset/HDR/MEFDatabase/fused_images/',image_name,'_zz01.png']);
        imwrite(img_result, ['G:/dataset/HDR/MEFDatabase/result/',image_name,'/result01.png']);
    end
    
    %% evalutate using MEF-SSIM
%     imgSeqColor = uint8(load_images(['G:/dataset/HDR/MEFDatabase/source_image_sequences/', image_name],1));
%     [s1, s2, s3, s4] = size(imgSeqColor);
%     imgSeq = zeros(s1, s2, s4);
%     for n = 1:s4
%         imgSeq(:, :, n) =  rgb2gray( squeeze( imgSeqColor(:,:,:,n) ) ); % color to gray conversion
%     end
%     fI1 = imread(['G:/dataset/HDR/MEFDatabase/fused_images/',image_name,'_zz01.png']);
%     fI1 = double(rgb2gray(fI1));
%     [Q(i,1), Qs1, QMap1] = mef_ms_ssim(imgSeq, fI1);
end
T = T/10