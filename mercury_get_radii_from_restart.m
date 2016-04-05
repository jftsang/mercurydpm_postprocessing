function radii = mercury_get_radii_from_restart(restart)
    radii = zeros(restart.nparticles,1);
    for i = 1:restart.nparticles
        radii(i) = restart.particles(i).radius;
    end
end
