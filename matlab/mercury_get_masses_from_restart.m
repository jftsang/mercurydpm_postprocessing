function masses = mercury_get_masses_from_restart(restart)
    radii = arrayfun(@(p) p.radius, restart.particles)';
    rhos = mercury_get_rhos_from_restart(restart);
    masses = (4/3)*pi*radii.^3.*rhos;
end

