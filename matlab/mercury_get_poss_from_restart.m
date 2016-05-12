%% mercury_get_poss_from_restart - get positions of individual particles from a 'restart' struct

function poss = mercury_get_poss_from_restart(restart)
    poss = zeros(restart.nparticles,3);
    for i = 1:restart.nparticles
        poss(i,:) = restart.particles(i).pos;
    end
end