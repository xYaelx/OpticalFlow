%%%%% test our optical flow implementation %%%%%
% question 2+3- Test the algorithm for 2 specific images
mov1 = VideoReader('cars5.avi');
seq1 = read(mov1);
im1 = seq1(:,:,:,10);
im2 = seq1(:,:,:,15);
sigma = 2;
region = [20,20];
checkOF(im1, im2,10, sigma,region);

%%% Part 4- playing with the algorithm parameters

% Test the algorithm for several pairs of images in videdos
% and playing with algorithm parameters
mov2 = VideoReader('people.avi');
seq2 = read(mov2);
im3 = seq2(:,:,:,7);
im4 = seq2(:,:,:,10);

 %% b- testing on various region sizes%%
 sigma = 2;
 regions = [5, 10, 15, 20, 30, 40, 50];
 [~,length]=size(regions);
 % test for first pair
 for i = 1 : length
     region = [regions(i), regions(i)];
     checkOF(im1, im2, sigma,region);
 end
 % test for second pair
 for i = 1 : length
     region = [regions(i), regions(i)];
     checkOF(im3, im4, sigma,region);
 end
 
%% b- testing on various smoothing sigma values %%
region = [30,30];
sigmas = [1, 3, 6, 10, 20, 30];
[~,length]=size(sigmas);
 % test for first pair
for i = 1 : length
    sigma = sigmas(i);
    checkOF(im1, im2, sigma,region);
end

 % test for second pair
 for i = 1 : length
    sigma = sigmas(i);
    checkOF(im3, im4, sigma,region);
 end

%% c- testing on the distance between the frames %%
region = [20,20];
sigma = 2;
%successive frames
for i = 1 : 6
    im1 = seq1(:,:,:,i);
    im2 = seq1(:,:,:,i+1);
    checkOF(im1, im2,i, sigma,region);
end

%jump of k different frames frames
diffs = [0, 3, 6, 10, 20, 30];
[~,length]=size(diffs);
for i = 1 : length
    im1 = seq1(:,:,:,1);
    im2 = seq1(:,:,:,1+diffs(i));
    checkOF(im1, im2,diffs(i), sigma,region);
end
%% Part 4 d - finding the perfect paranmeters
%%% sequence 1
mov1 = VideoReader('cars5.avi');
sigma = 2;
region = [25,25];
k=7;
% sending the parameters and find and plot the optical flow
checkOF_seq(mov1, sigma, region,k)

%%% sequence 2
mov2 = VideoReader('people.avi');
sigma = 3;
region = [20,20];
k=3;
% sending the parameters and find and plot the optical flow
checkOF_seq(mov2, sigma, region,k)

 %% Part 6- testing on various distance between the frames%%
region = [20,20];
sigma = 2;
im1 = seq2(:,:,:,2);
im2 = seq2(:,:,:,4);
im3= seq2(:,:,:,10);
sizes = [0.2,0.4,0.6,0.8,1];
[~,length]=size(sizes);
%check for a small distance between the frames
for i = 1 : length
    new_im1 = imresize(im1,sizes(i));
    new_im2 = imresize(im2,sizes(i));
    checkOF(new_im1, new_im2,i, sigma,region);
end
%check for a big distance between the frames
for i = 1 : length
    new_im1 = imresize(im1,sizes(i));
    new_im2 = imresize(im3,sizes(i));
    checkOF(new_im1, new_im2,i, sigma,region);
end

%% Part 8 - Size segmented image - pair of frames
 
% Video data
MOV = VideoReader('data\SLIDE.avi');
seq = read(MOV);
Im1 = rgb2gray(seq(:,:,:,1));
Im2 = rgb2gray(seq(:,:,:,3));

% Im1=imresize(Im1,0.3); %resize the image
% Im2=imresize(Im2,0.3); %resize the image

smooth = 5;
region = 20;
threshold = 1.5;

[U, V, M, O] = OF(Im1, Im2, smooth, [region, region]);
seg = seg_OF_size (M, threshold);

figure;
imshow(seg,[]);
str = sprintf('Size segmented image \n Parameters: smooth = %d, region = %d, threshold = %d', smooth, region, threshold);
title(str);
figure;
imshow(Im1,[]);
str = sprintf('Original image: frame 2');
title(str);


%% Part 8 - Size segmented image - entire sequence / a part of the sequence
MOV = VideoReader('data\SLIDE.avi');
seq = read(MOV);

smooth = 4;
region = 20;
threshold = 1;

for i=[1:15 60:70] 
% for i=[60:70] 
   Im1=rgb2gray(seq(:,:,:,i)); %convert to gray scale
   Im2=rgb2gray(seq(:,:,:,i+1)); %convert to gray scale
%    Im1=imresize(Im1,0.3); %resize the image
%    Im2=imresize(Im2,0.3); %resize the image
%    imshow(Im1,[]);
%     hold on;
        
    [U, V, M, O] = OF(Im1, Im2, smooth, [region, region]);
    
    seg = seg_OF_size (M, threshold);

    figure;
    imshow(seg,[]);
    str = sprintf('Size segmented image \nFrame %d, Parameters: smooth = %d, region = %d, threshold = %d', i, smooth, region, threshold);
    title(str);

    figure;
    imshow(Im1,[]);
    str = sprintf('Original image: frame %d', i);
    title(str);
    % 
    %     pause(0.1);
    %     hold off;
end

%% Part 8 - Size segmented image - entire sequence write to file
% NOT WORKING for some reason - PLEASE IGNORE!

MOV = VideoReader('data\people.avi');
seq = read(MOV);
seq2 = seq;

smooth = 5;
region = 20;
threshold = 1.5;
for i=1:size(seq,4)-1
    
   Im1=rgb2gray(seq(:,:,:,i)); %convert to gray scale
   Im2=rgb2gray(seq(:,:,:,i+1)); %convert to gray scale
    [U, V, M, O] = OF(Im1, Im2, smooth, [region, region]);
% Threshold must be a value between 0 and 1 which is then multiplied by
% the optical flow range.
    seg = seg_OF_size (M, threshold);
    size(seg)
    seq2(:,:,:,i)=seg; 
end;
vidObj = VideoWriter('people_magnitude.avi');
open(vidObj);
for i=1:size(seq,4)-1, writeVideo(vidObj,seq2(:,:,:,i)); end
close(vidObj);





%% Part 9 - Direction segmented image - pair of frames

MOV = VideoReader('data\people.avi');
seq = read(MOV);
Im1 = rgb2gray(seq(:,:,:,9));
Im2 = rgb2gray(seq(:,:,:,10));

smooth = 4;
region = 20;

[U, V, M, O] = OF(Im1, Im2, smooth, [region, region]);
% Threshold must be a values between -pi and pi 
seg = seg_OF_direction(O, [-pi/2, 0, pi/2]); 
figure;
imshow(seg,[]);
str = sprintf('Direction segmented image \n frame: %d Parameters: smooth = %f, region = %f', smooth, region);
title(str);
figure;
imshow(Im1,[]);
str = sprintf('Original image: frame %d', 9);
title(str);

%% Part 9 - Direction segmented image - entire sequence / part of the sequence 

MOV = VideoReader('data\people.avi');
seq = read(MOV);

smooth = 4;
region = 20;

for i=1:9
   Im1=rgb2gray(seq(:,:,:,i)); %convert to gray scale
   Im2=rgb2gray(seq(:,:,:,i+1)); %convert to gray scale
   
%    Im1=imresize(Im1,0.3); %resize the image
%    Im2=imresize(Im2,0.3); %resize the image
%    hold on;
    
    [U, V, M, O] = OF(Im1, Im2, smooth, [region, region]);
    % Threshold must be a values between -pi and pi 
    seg = seg_OF_direction(O, [-pi/2, 0, pi/2]); 
    figure;
    imshow(seg,[]);
    str = sprintf('Direction segmented image \n frame: %d Parameters: smooth = %f, region = %f', i, smooth, region);
    title(str);

    figure;
    imshow(Im1,[]);
    str = sprintf('Original image: frame %d', i);
    title(str);
%   imshow(seg,[]);
% 
%   pause(0.1);
%   hold off;
end
