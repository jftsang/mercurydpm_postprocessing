%% jmft2's test suite for MercuryDPM-related MATLAB functions.

% Do not run this whole script all in one go! Things will take far too long
% to finish. Run one section at a time.
error('Are you sure you want to run this script all in one go?');

%% Initialisation.
% Load particle path data.
% Load only one file at a time, because these tend to be quite heavy on
% memory and take quite long. 

% data_free_fall = mercury_load_data('free_fall.data');
% data_elastic_collision = mercury_load_data('elastic_collision.data');
% data_inclined_plane = mercury_load_data('inclined_plane.data');
% data_free_cooling = mercury_load_data('free_cooling.data');
% data_free_fall_with_fixed_particle = mercury_load_data('free_fall_with_fixed_particle.data');
data_twoplanes = mercury_load_data('twoplanes.data');
% data_free_cooling3D = mercury_load_data('data_free_cooling3D', 0.001);

% Load energy history.
% ene_inclined_plane = mercury_load_ene('inclined_plane.ene');
% ene_free_cooling = mercury_load_ene('free_cooling.ene');
ene_twoplanes = mercury_load_ene('twoplanes.ene');

% Finalise initialisation.
data = data_twoplanes;
dt = data.ts(2) - data.ts(1);
ene = ene_twoplanes;

%% Plotting particle paths
% subplot(2,4,1);
subplot(2,2,1);
for i = 1:length(data.particles)
    plot(data.particles(i).x, data.particles(i).y);
    hold on;
end
hold off;
axis equal;

%{
subplot(4,4,2);
for i = 1:length(data.particles)
    plot(data.ts, data.particles(i).x);
    hold on;
end
hold off;

subplot(4,4,6);
for i = 1:length(data.particles)
    plot(data.ts, data.particles(i).y);
    hold on;
end
hold off;
%}

%% Plotting graph of energy history
% has been moved to mercury_test_ene_hist.m

%% Plotting history of distribution of kinetic energy
%{
subplot(2,2,3);
kess = mercury_get_kes(data);
plot( ...
    kess.ts, prctile(kess.kes, 5), 'b:', ...
    kess.ts, prctile(kess.kes, 25), 'b--', ...
    kess.ts, prctile(kess.kes, 50), 'b-', ...
    kess.ts, prctile(kess.kes, 75), 'b--', ...
    kess.ts, prctile(kess.kes, 95), 'b:' ...
);
%}

%% Dynamic mode decomposition (for statistics when (and only when) we have many particles)
addpath('~/Documents/granular-mechanics/grain/MATLAB/vchute/aug2015');
% Note: have _columns_ representing different time frames.
% For data_free_cooling, we have n=101 frames and each frame contains 
% p=1024 pieces of data. 
% We don't need to have very many frames for DMD.
koopman_kes = dynamic_mode_decomposition( kess.kes );
subplot(2,2,4);
%{
plot3(real(koopman_kes.evals), imag(koopman_kes.evals), log10(abs(koopman_kes.compamp)), 'kx');
xlabel('Re(\lambda)'); ylabel('Im(\lambda)'); zlabel('log10(abs(amp))');
grid;
axis([-1.5, 1.5, -1.5, 1.5, 0, 0.1]);
axis equal;
axis('auto z');
%}

plot3(log(abs(koopman_kes.evals))/dt, ...
    angle(koopman_kes.evals)/dt, ...
    log10(abs(koopman_kes.compamp)), 'kx');
xlabel('\sigma'); ylabel('\omega'); zlabel('log10(abs(amp))');
axis([0, 1, 0, max(angle(koopman_kes.evals)/dt), 0, 1]);
axis('auto xz');