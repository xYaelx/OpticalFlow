 %% optical flow implementation %%
function checkOF(im1, im2,k, sigma,region)
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
    [U,V,~,~]= OF(im1,im2, sigma, region);
    [X, Y]=meshgrid(1:size(im1,2),1:size(im1,1)); 
    nu12 = medfilt2(U,[5 5]);
    nv12 = medfilt2(V,[5 5]);
    figure; imshow(im1,[]);
    hold on;
    quiver(X(1:5:end,1:5:end),Y(1:5:end,1:5:end),nu12(1:5:end,1:5:end),...
    nv12(1:5:end,1:5:end),5);
    str = sprintf('Parameters: smooth=%d , region :%f,%f , frame:%d',...
        sigma,region(1),region(2),k);
    title(str);
    hold off;
    pause(0.1);

end
