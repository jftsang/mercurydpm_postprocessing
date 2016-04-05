%% mercury_get_vol_frac - return the volume fraction at certain positions

function vol_frac = mercury_get_vol_frac(frame, xqs, yqs, zqs)
    if nargin < 4
        % two-dimensional problem
        vol_frac.dimensions = 2;
        zqs = 0;
    else
        vol_frac.dimensions = 3;
    end
    vol_frac.xqs = xqs;
    vol_frac.yqs = yqs;
    vol_frac.zqs = zqs;
    
    if (vol_frac.dimensions == 2)
        for i = 1:length(xqs)
            for j = 1:length(yqs)
                vol_frac.phis(i,j) = vol_frac_workhorse(frame,[xqs(i), yqs(j), 0]);
            end
        end
    elseif (vol_frac.dimensions == 3)
        for i = 1:length(xqs)
            for j = 1:length(yqs)
                for k = 1:length(zqs)
                    vol_frac.phis(i,j,k) = vol_frac_workhorse(frame,[xqs(i), yqs(j), zqs(k)]);
                end
            end
        end
    end
end

function phi = vol_frac_workhorse(frame, posq)
    phi = sum( arrayfun( @(p) ...
                        heaviside(p.radius - norm(p.pos - posq)), ...
    frame.particles));
end