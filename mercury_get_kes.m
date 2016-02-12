%% mercury_get_kes - get KEs of individual particles from a 'data' struct
function kes = mercury_get_kes(data)
    kes.ts = data.ts;
    for i = 1:length(data.particles)
        kes.particles(i,:) = (4/3)*pi*data.particles(i).radius.^3 .* ...
            (data.particles(i).vx.^2 + data.particles(i).vy.^2);
    end
end