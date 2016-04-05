% Centre of mass in y, as a function of x. See notes for definition. 
% Depends on extractfield: 
% extractfield(frame.particles, 'pos')
% example usage:
%{
xs = linspace(data.boundingbox(1), data.boundingbox(2), 256);
ycmfx = arrayfun(@(x) mercury_ycom_fnx(data.frames(1), x), xs);
plot(xs, ycmfx);
%}

function ycom_fnx = mercury_ycom_fnx(frame, x) 
    num = 0; den = 0;
    for (i = 1:length(frame.particles))
        p = frame.particles(i);
        num = num + p.pos(2) * p.mass * kernel_normal(x - p.pos(1), p.radius);
        den = den + p.mass * kernel_normal(x - p.pos(1), p.radius);
    end
    ycom_fnx = num/den;
end