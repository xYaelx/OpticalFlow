function [ seg ] = seg_OF_direction(O, ths) 
% O: optical flow orientation
% ths: threshold values which should be between pi and -pi.
% Output: segmented image – each segment in a different color (grayscale).
% This function detects pixels that move in the same direction. 

% Sort threshold values in ascending order
ths = sort(ths);
ths = ths';
 
seg = ones(size(O));
%set 0 to pixels with orientention lower than all thresholds (set
%backgroung black)
seg(O >= -pi & O < ths(1)) = 0;

%set the same value to pixels with orientention between 2 thresholds
for i = 1: size(ths)-1
    seg(O >= ths(i) & O < ths(i+1)) = i;
end
seg(O >= ths(i+1) & O < pi) = i+1;

end

