%% jmft2's test suite for MercuryDPM-related MATLAB functions.

%% Initialisation.
% Load particle path data.
% Load only one file at a time, because these tend to be quite heavy on
% memory and take quite long. 

% data_free_fall = mercury_load_data('free_fall.data');
% data_elastic_collision = mercury_load_data('elastic_collision.data');
% data_inclined_plane = mercury_load_data('inclined_plane.data');
data_free_cooling = mercury_load_data('free_cooling.data');
data_free_fall_with_fixed_particle = mercury_load_data('free_fall_with_fixed_particle.data');

% Load energy history.
ene_free_cooling = mercury_load_ene('free_cooling.ene');

% Finalise initialisation.
data = data_free_cooling;
ene = ene_free_cooling;

%% Plotting particle paths
figure(1); 
for i = 1:length(data.particles)
    plot(data.particles(i).x, data.particles(i).y);
    hold on;
end
hold off;
axis equal;

%% Plotting energy graph
figure(2); 
ene.ene_tot = ene.ene_gra + ene.ene_kin + ene.ene_rot + ene.ene_ela;
plot(ene.ts, ene.ene_gra, 'g', ...
    ene.ts, ene.ene_kin, 'b', ...
    ene.ts, ene.ene_rot, 'r', ...
    ene.ts, ene.ene_ela, 'y', ...
    ene.ts, ene.ene_tot, 'k');
legend('gra','kin','rot','ela','tot');

%% Plotting distribution of kinetic energy
figure(3); 
kes = mercury_get_kes(data);
plot( ...
    kes.ts, prctile(kes.particles, 5), 'b:', ...
    kes.ts, prctile(kes.particles, 25), 'b--', ...
    kes.ts, prctile(kes.particles, 50), 'b-', ...
    kes.ts, prctile(kes.particles, 75), 'b--', ...
    kes.ts, prctile(kes.particles, 95), 'b:' ...
);