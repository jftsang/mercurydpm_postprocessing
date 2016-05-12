%% mercury_get_kes_from_data - get KEs of individual particles from a 'data' struct as functions of time
% This returns a struct kess containing a 2d array kes.kes, whose rows
% index over different times and each row gives the distribution of KEs at
% that time. 
% 
% This may be too much information.

% TODO - we are assuming that all particles have a density of 1. 
function kess = mercury_get_kes_from_data(data)
    kess.ts = data.ts;
    for i = 1:length(data.frames)
        kess.frames(i).t = data.frames(i).t;
        kess.frames(i).kes = arrayfun( ...
                @(p) (4/3) * pi * p.radius^3 * norm(p.vel)^2, ...
                data.frames(i).particles );
    end
end

