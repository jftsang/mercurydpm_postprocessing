% Get a component of the velocity field, as a function of x and z. 
% See notes for definition. 
% Example:
%{
frame = data.frames(30);
poss = extractfield(frame.particles, 'pos');
vels = extractfield(frame.particles, 'vel');
rs = extractfield(frame.particles, 'radius');
ms = extractfield(frame.particles, 'mass');

xs = linspace(data.boundingbox(1), data.boundingbox(2), 32);
zs = linspace(data.boundingbox(5), data.boundingbox(6), 32);
[xs,zs] = meshgrid(xs,zs);
tic; 
usfxz = arrayfun(@(x,z) mercury_us_fnxz(poss, vels, rs, ms, 1, x, z), xs, zs);
toc;
mesh(xs,zs,usfxz); view(2);
%}

function us_fnxz = mercury_us_fnxz(poss, vels, rs, ms, ucomponent, x, z) 
    xs = poss(:,1);
    zs = poss(:,3);
    us = vels(:,ucomponent); 
    
    kxs = zeros(size(xs));
    kzs = zeros(size(xs));
    num_summands = zeros(size(xs));
    den_summands = zeros(size(xs));
    
    for i = 1:length(xs)
        sx = rs(i); sz = rs(i);
        kxs(i) = sx/(pi*(sx^2 + (x-xs(i))^2));
        kzs(i) = sz/(pi*(sz^2 + (z-zs(i))^2));
        
        num_summands(i) = us(i) * ms(i) * kxs(i) * kzs(i);
        den_summands(i) = ms(i) * kxs(i) * kzs(i);
    end
    num = sum(num_summands);
    den = sum(den_summands);
    if (den == 0 && num == 0) 
        us_fnxz = 0;
    else
        us_fnxz = num/den;
    end
%     fprintf('%f %f %e %e %f\n', x, y, num, den, zcom_fnxy);
end