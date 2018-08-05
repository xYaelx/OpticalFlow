function checkOF_seq(mov, sigma, region,k)
    seq = read(mov);
    for i = 1 : mov.NumberOfFrames-k
        im1 = seq(:,:,:,i);
        im2 = seq(:,:,:,i+k);
        checkOF(im1, im2,i, sigma,region);
    end
end