%% mercury_get_vels_from_restart - get velocities of individual particles from a 'restart' struct

function vels = mercury_get_vels_from_restart(restart)
    vels = zeros(restart.nparticles,3);
    for i = 1:restart.nparticles
        vels(i,:) = restart.particles(i).vel;
    end
end