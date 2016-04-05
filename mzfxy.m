% Test for mercury_zcom_fnxy.

tic;
% data = mercury_load_data('split.3390');
xs = linspace(data.boundingbox(1), data.boundingbox(2), 101);
ys = linspace(data.boundingbox(3), data.boundingbox(4), 21);
[xs,ys] = meshgrid(xs,ys);
% tic; 
% This seems to take very long, for (101,21). 

frame = data.frames(1);
poss = extractfield(frame.particles, 'pos');
rs = extractfield(frame.particles, 'radius');
ms = extractfield(frame.particles, 'mass');

zcmfxy = arrayfun(@(x,y) mercury_zcom_fnxy(poss, rs, ms, x, y), xs, ys);
toc;

%% Graphics.
mesh(xs,ys,zcmfxy); 
view(2); colormap jet; colorbar;
h = 0.1; % This depends on your data.
axis([0 5 -1 1 0 h]); caxis([0 h]);