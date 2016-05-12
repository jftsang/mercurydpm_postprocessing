% Temperature has units of (velocity)^2, but as an average velocity, it is
% weighted by the mass of each particles.
% TODO fix
function temperature = mercury_get_temperature_from_restart(restart)
    masses = mercury_get_masses_from_restart(restart);
    vels = mercury_get_vels_from_restart(restart);
    ps = repmat(masses,[1,3]) .* vels;
    ps = ps - repmat(mean(ps),[size(ps,1), 1]);
    norms = arrayfun(@(idx) norm(ps(idx,:)), 1:size(ps,1))';
    temperature = mean(norms ./ masses);
end