% Centre of mass in z, as a function of x and y. See notes for definition. 
% Depends on extractfield: 
% extractfield(frame.particles, 'pos')
% example usage:
%{
xs = linspace(data.boundingbox(1), data.boundingbox(2), 64);
ys = linspace(data.boundingbox(3), data.boundingbox(4), 64);
[xs,ys] = meshgrid(xs,ys);
tic; % This seems to take very long, for (101,21). 
zcmfxy = arrayfun(@(x,y) mercury_zcom_fnxy(data.frames(1), x, y), xs, ys);
toc;
mesh(xs,ys,zcmfxy); 
view(2); colormap jet; colorbar;
h = 0.1; % This depends on your data.
axis([0 5 -1 1 0 h]); caxis([0 h]); 
%}

function zcom_fnxy = mercury_zcom_fnxy(poss, rs, ms, x, y) 
    xs = poss(:,1);
    ys = poss(:,2);
    zs = poss(:,3);
    
    % TODO Find some way of speeding this up. Probably will need to use
    % parallelisation. On my laptop, only two cores are available to the
    % parallel pool, although I suspect this should run nicely on the DAMTP
    % cluster. 
    for i = 1:length(xs)
        % Evaluating kernel_normal is actually really slow...
        kxs(i) = kernel_normal(x-xs(i), rs(i));
        kys(i) = kernel_normal(y-ys(i), rs(i));
        num_summands(i) = zs(i) * ms(i) * kxs(i) * kys(i);
        den_summands(i) = ms(i) * kxs(i) * kys(i);
    end
    num = sum(num_summands);
    den = sum(den_summands);
    if (den == 0 && num == 0) 
        zcom_fnxy = 0;
    else
        zcom_fnxy = num/den;
    end
%     fprintf('%f %f %e %e %f\n', x, y, num, den, zcom_fnxy);
end