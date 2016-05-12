%% mercury_test_ene_hist.m - plot graph of energy history

%% loading
% ene = mercury_load_ene('free_cooling3D.ene')
% restart = mercury_load_restart('free_cooling3D.restart')

ene.ene_tot = ene.ene_gra + ene.ene_kin + ene.ene_rot + ene.ene_ela;

%% history of energy
subplot(2,2,2);
plot(ene.ts, ene.ene_gra, 'g', ...
    ene.ts, ene.ene_kin, 'b', ...
    ene.ts, ene.ene_rot, 'r', ...
    ene.ts, ene.ene_ela, 'y', ...
    ene.ts, ene.ene_tot, 'k');
legend('gra','kin','rot','ela','tot');
axis tight;
xlabel('time');
ylabel('energy');
title('history of energy');

%% Plot graph of KE distribution

subplot(2,2,3);
kes = mercury_get_kes_from_restart(restart);
hist(kes,20);
xlabel('KE');
ylabel('number of particles');
title('distribution of KE amongst particles');