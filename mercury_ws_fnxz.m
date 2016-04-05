% Get a component of the velocity field, as a function of x and z. See notes for definition. 
%{
xs = linspace(data.boundingbox(1), data.boundingbox(2), 64);
zs = linspace(data.boundingbox(5), data.boundingbox(6), 64);
[xs,zs] = meshgrid(xs,zs);
tic; 
wcmfxz = arrayfun(@(x,y) mercury_zcom_fnxy(data.frames(1), x, y), xs, ys);
toc;
mesh(xs,ys,zcmfxy); 
%}

function ws_fnxz = mercury_ws_fnxz(poss, vels, rs, ms, component, x, z) 
    xs = poss(:,1);
    zs = poss(:,3);
    ws = vels(:,component); 
    
    for i = 1:length(xs)
        sx = rs(i); sz = rs(i);
        kxs(i) = sx/(pi*(sx^2 + (x-xs(i))^2));
        kzs(i) = sz/(pi*(sz^2 + (z-zs(i))^2));
        
        num_summands(i) = ws(i) * ms(i) * kxs(i) * kzs(i);
        den_summands(i) = ms(i) * kxs(i) * kzs(i);
    end
    num = sum(num_summands);
    den = sum(den_summands);
    if (den == 0 && num == 0) 
        ws_fnxz = 0;
    else
        ws_fnxz = num/den;
    end
%     fprintf('%f %f %e %e %f\n', x, y, num, den, zcom_fnxy);
end