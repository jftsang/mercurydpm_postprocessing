% Test for mercury_ws_fnxz.
tic;
% data = mercury_load_data('split.3390');
xs = linspace(data.boundingbox(1), data.boundingbox(2), 101);
zs = linspace(0, .14, 29);
[xs,zs] = meshgrid(xs,zs);

% This seems to take very long, for (101,21). 
frame = data.frames(1);
% extracting fields is surprisingly costly and is unnecessary after the 
% first time
%{ 
poss = extractfield(frame.particles, 'pos');
vels = extractfield(frame.particles, 'vel');
rs = extractfield(frame.particles, 'radius');
ms = extractfield(frame.particles, 'mass');
%}
toc;
vfxz = arrayfun(@(x,z) mercury_ws_fnxz(poss, vels, rs, ms, 1, x, z), xs, zs);
toc;

%% Graphics.
figure;
surf(xs, zs, vfxz, 'EdgeColor', 'none'); 
view(2); colormap jet; colorbar;
axis([0 5 0 .14]); caxis([-.4,.05])
