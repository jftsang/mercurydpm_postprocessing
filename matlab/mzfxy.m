% Test for mercury_zcom_fnxy.

tic;
% data = mercury_load_data('split.3390');
xs = linspace(data.boundingbox(1), data.boundingbox(2), 101);
ys = linspace(-.2, .2, 41);
[xs,ys] = meshgrid(xs,ys);
% tic; 

% This seems to take very long, for (101,21). 
frame = data.frames(1);
poss = extractfield(frame.particles, 'pos');
vels = extractfield(frame.particles, 'vel');
rs = extractfield(frame.particles, 'radius');
ms = extractfield(frame.particles, 'mass');

zcmfxy = arrayfun(@(x,y) mercury_zcom_fnxy(poss, vels, rs, ms, x, y), xs, ys);
toc;

%% Graphics.
figure;
mesh(xs,ys,zcmfxy); 
view(2); colormap jet; colorbar;
h = .1; % This depends on your data.
axis([0 5 -1 1]); caxis([0.04 h]);