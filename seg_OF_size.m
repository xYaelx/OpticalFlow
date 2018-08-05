function [ seg ] = seg_OF_size (M, th)
% M: optical flow magnitude
% Th: a threshold number
% Output: segmented image – each segment in a different color (grayscale).
% Detects pixels with large optical flow as foreground and low optical flow 
% as background (|M|>th) and displays the results.

BW = ones(size(M));
BW(M <= th) = 0;

seg = bwlabeln(logical(BW));
end
