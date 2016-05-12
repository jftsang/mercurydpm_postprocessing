function rhos = mercury_get_rhos_from_restart(restart)
    rhos = zeros(restart.nparticles,1);
    for i = 1:restart.nparticles
        rhos(i) = restart.species(restart.particles(i).species+1).rho;
    end
end
