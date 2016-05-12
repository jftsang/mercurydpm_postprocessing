%% mercury_get_kes_from_restart - get KEs of individual particles from a 'restart' struct.
% This returns an array kes which contains the distribution of KEs of the
% particles listed in the 'restart' struct.
% 
% That is, this gives the distribution of kinetic energies at the time of
% the 'restart' struct. 
function kes = mercury_get_kes_from_restart(restart)
    kes = zeros(1,restart.nparticles);
    for i = 1:restart.nparticles
        kes(i) = (4/3)*pi*restart.particles(i).radius.^3 ...
            * norm(restart.particles(i).vel)^2 ...
            * restart.species(restart.particles(i).species+1).rho;
    end
end

