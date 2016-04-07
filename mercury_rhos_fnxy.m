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
[xs,ys] = meshgrid(xs,ys);
tic; 
rhofxy = arrayfun(@(x,y) mercury_rhos_fnxy(poss, rs, ms, x, y), xs, ys);
toc;
%}

function rhos_fnxy = mercury_rhos_fnxy(poss, rs, ms, x, y) 
    xs = poss(:,1);
    ys = poss(:,2);
    
    for i = 1:length(xs)
        sx = rs(i); sy = rs(i); sz = rs(i);
        kxs = sx/(pi*(sx^2 + (x-xs(i))^2));
        kys = sy/(pi*(sy^2 + (y-ys(i))^2));
        
        summands(i) = ms(i) * kxs * kys;
    end
    rhos_fnxy = sum(summands);
end