function [Dx, Dy] = derivatives(image)
    a=[-1 0 1];
    Dx=conv2(image,a,'same');
    Dy=conv2(image,a','same');
end