%%%%% optical flow implementation %%%%%
function [U,V, M,O]= OF(F1,F2, Sigma_S, region)
%%%%
% optical flow components - U, V
%%%%
    F1=double(F1);
    F2=double(F2);
    %Smooth the 2 images
    size_mask = 7;
    mask = Gauss_mask(Sigma_S, size_mask);
    smoothF1=conv2(F1,mask,'same');
    smoothF2=conv2(F2,mask,'same');

    % deriveites by x and y for picture 1 
    dir=[-1 0 1];
    Idx=conv2(smoothF1,dir,'same');
    Idy=conv2(smoothF1,dir','same');

    % deriveite by time 
    Idt=smoothF2-smoothF1;
    
    [height, width] = size(F1);
    U = zeros(height, width);
    V = zeros(height, width);
    
    % computing the derivetive matrix for each patch(region)
    half_patch_height = floor(region(1)/2);
    half_patch_width = floor(region(2)/2);

    % indexes for patch borders
    col_indexes = meshgrid(1:width,1:height);
    row_indexes = meshgrid(1:height,1:width)';
    % Matrix of indexes determining the top row of the patch for each pixel
    top_row_index = max(1, row_indexes - half_patch_height);
    % Matrix of indexes determining the bottom row of the patch for each pixel
    bottom_row_index = min(height, row_indexes + half_patch_height);
    % Matrix of indexes determining the left column of the patch for each pixel
    left_col_index = max(1, col_indexes - half_patch_width);
    % Matrix of indexes determining the right column of the patch for each pixel
    right_col_index = min(width, col_indexes + half_patch_width);

    for i = 1 : height
        for j = 1 : width
            Idx_patch = Idx(top_row_index(i,j):bottom_row_index(i,j), left_col_index(i,j):right_col_index(i,j));
            Idy_patch = Idy(top_row_index(i,j):bottom_row_index(i,j), left_col_index(i,j):right_col_index(i,j));
            Idt_patch = Idt(top_row_index(i,j):bottom_row_index(i,j), left_col_index(i,j):right_col_index(i,j));

            % for each pixel compute A, b and G
            A = [Idx_patch(:), Idy_patch(:)];
            b = -1*double(Idt_patch(:));
            G = A'*A;
            if rank(G) == 2
                uv = A\b;
                U(i, j) = uv(1);
                V(i, j) = uv(2);
            end

        end
    end

    % calculate flow magitude = norm of U and V
    M = sqrt( U.^2 + V.^2);
%todo check if we should convert to degrees
    % direction of the flow magitude
    O = atan2(V, U);
%     O = radtodeg(O);
end