clear all;
close all;

%% add path of a folder including support functions
addpath('functions');

%% assign input and output directory
input_folder = './image_sequence';
output_file = './result.png';

%% read multi-exposed rgb image sequence (scaling to [0,1])
imgs_rgb = load_images(input_folder,1);
imgs_rgb = imgs_rgb/255.0;

%% compute luminance image of rgb image sequence
imgs_lum = rgb2lum(imgs_rgb);

%% compute weight1 using luminance distribution
w1 = get_weight1(imgs_lum);

%% compute weight2 using luminance gradient
w2 = get_weight2(imgs_lum);

%% corporate weight1 & weight2 and refine weight with wlsFilter
p1 = 1;
p2 = 1;
w = (w1.^p1).*(w2.^p2);
w = refine_weight(w);

%% fuse images using pyramid decomposition
lev = 7;
img_result = fusion_pyramid(imgs_rgb, w, lev);

%% show and save result image (optional)
figure();
imshow(img_result);
want_to_save_result = 1;
if (want_to_save_result)
    imwrite(img_result, output_file);
end
