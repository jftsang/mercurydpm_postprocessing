% Get the density field, as a function of x, y, z. 
% See notes for definition. 
%{
frame = data.frames(1);
poss = extractfield(frame.particles, 'pos');
vels = extractfield(frame.particles, 'vel');
rs = extractfield(frame.particles, 'radius');
ms = extractfield(frame.particles, 'mass');

xs = linspace(data.boundingbox(1), data.boundingbox(2), 64);
ys = linspace(data.boundingbox(3), data.boundingbox(4), 64);
zs = linspace(data.boundingbox(5), data.boundingbox(6), 64);
[xs,ys,zs] = meshgrid(xs,ys,zs);
tic; 
rhofxyz = arrayfun(@(x,y,z) mercury_rhos_fnxyz(poss, rs, ms, x, y, z), xs, ys, zs);
toc;
%}

function rhos_fnxyz = mercury_rhos_fnxyz(poss, rs, ms, x, y, z) 
    xs = poss(:,1);
    ys = poss(:,2);
    zs = poss(:,3);
    
    for i = 1:length(xs)
        sx = rs(i); sy = rs(i); sz = rs(i);
        kxs = sx/(pi*(sx^2 + (x-xs(i))^2));
        kys = sy/(pi*(sy^2 + (y-ys(i))^2));
        kzs = sz/(pi*(sz^2 + (z-zs(i))^2));
        
        summands(i) = ms(i) * kxs * kys * kzs;
    end
    rhos_fnxyz = sum(summands);
end