% Get a component of the velocity field, as a function of x. 
% See notes for definition. 
% Example: 
%{
frame = data.frames(30);
poss = extractfield(frame.particles, 'pos');
vels = extractfield(frame.particles, 'vel');
rs = extractfield(frame.particles, 'radius');
ms = extractfield(frame.particles, 'mass');

xs = linspace(0, 20, 512);
tic; 
usfx = arrayfun(@(x) mercury_us_fnx(poss, vels, rs, ms, 1, x), xs);
toc;
plot(xs,usfx); 
%}

function us_fnx = mercury_us_fnx(poss, vels, rs, ms, component, x) 
    xs = poss(:,1);
    us = vels(:,component); 
    kxs = zeros(size(xs));
    num_summands = zeros(size(xs));
    den_summands = zeros(size(xs));
    
    for i = 1:length(xs)
        sx = rs(i); 
        kxs(i) = sx/(pi*(sx^2 + (x-xs(i))^2));
        
        num_summands(i) = us(i) * ms(i) * kxs(i);
        den_summands(i) = ms(i) * kxs(i);
    end
    num = sum(num_summands);
    den = sum(den_summands);
    if (den == 0 && num == 0) 
        us_fnx = 0;
    else
        us_fnx = num/den;
    end
%     fprintf('%f %f %e %e %f\n', x, y, num, den, zcom_fnxy);
end