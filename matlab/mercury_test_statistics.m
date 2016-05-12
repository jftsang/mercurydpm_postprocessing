%% mercury_test_statistics.m - statistics from a .restart file

% restart_3D = mercury_load_restart('free_cooling3D.restart');
kes = mercury_get_kes_restart(restart_3D);
hist(kes,20);