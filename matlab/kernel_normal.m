function w = kernel_normal(x,sigma) 
    if nargin < 2
        sigma = 1;
    end
    w = 1/(sqrt(2*pi)*sigma) * exp(-(x/sigma)^2/2);
end