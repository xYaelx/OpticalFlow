function mask = Gauss_mask(sigma, mask_size)
    % Generate horizontal and vertical co-ordinates, where the origin is 
    %in the middle
    mask_size= floor(mask_size/2);
    ind = (-mask_size) : mask_size;
    [X, Y] = meshgrid(ind, ind);
    % Create Gaussian Mask
    mask = exp(-(X.^2 + Y.^2) / (2*sigma^2));
    % normalize mask
    mask=mask./sum(mask(:));
end

