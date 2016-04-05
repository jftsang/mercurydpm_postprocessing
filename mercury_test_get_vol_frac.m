%% mercury_test_get_vol_frac
% data = mercury_load_data('free_cooling.data');
boundingbox = data.boundingbox;
frame = data.frames(1);
vol_frac = mercury_get_vol_frac(frame, ...
                                linspace(boundingbox(1), boundingbox(2), 40), ...
                                linspace(boundingbox(3), boundingbox(4), 40) ...
                            );
mesh(vol_frac.xqs, vol_frac.yqs, vol_frac.phis);
view(2);
axis equal;

%% with chute_demo
% restart_chute = mercury_load_restart('chute_demo.restart');
xqs = linspace(0,0.1,41);
zqs = linspace(0,0.12,49);
vol_frac_chute = mercury_get_vol_frac(restart_chute, xqs, 0.001, zqs);
[xqs, zqs] = meshgrid(xqs, zqs);
mesh(xqs, zqs, ...
    permute(vol_frac_chute.phis, [3 1 2]) ...
);
view(2);
colorbar;
axis equal;