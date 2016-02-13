%% mercury_load_restart - load a .restart file produced by MercuryDPM
% The .restart file contains such information as the locations of the
% bounding box and of walls and other obstacles, as well as the position
% and velocity of each particle at the end of the simulation, should one
% wish to continue the simulation from that point. 

% TODO - not sure if this will work for all MercuryDPM .restart outputs,
% although it appears that, unlike .data and .ene files, .restart files 
% don't depend on whether the simulation is 2d or 3d. 

function restart = mercury_load_restart(filename) 
    tic;
    restart.filename = filename;
    f = fopen(filename);
    % loop over lines in a file
    % http://uk.mathworks.com/matlabcentral/answers/77725-i-need-to-use-for-loop-to-read-the-names-from-a-text-file-using-fgetl-function-how-do-i-do-that
    line = fgetl(f); ln = 1;
    while(ischar(line)) 
        lineargs = strsplit(line);
        if (strcmp(lineargs{1}, 'restart_version'))
            % restart_version - TODO study this
            if (~strcmp(lineargs{2}, '3')) 
                warning('restart_version is not equal to 3');
            end
            restart.restart_version = lineargs{2};
        elseif (strcmp(lineargs{1}, 'name'))
            % simulation title
            restart.name = lineargs{2};
        elseif (strcmp(lineargs{1}, 'xmin'))
            if( ...
                    ~strcmp(lineargs{3}, 'xmax') | ...
                    ~strcmp(lineargs{5}, 'ymin') | ...
                    ~strcmp(lineargs{7}, 'ymax') | ...
                    ~strcmp(lineargs{9}, 'zmin') | ...
                    ~strcmp(lineargs{11}, 'zmax') )            
                warning('%s:%d unorthodox formatting for bounding box specification', ln, filename);
            end
            % bounding box information
            restart.boundingbox = [...
                str2double(lineargs{2}), ...
                str2double(lineargs{4}), ...
                str2double(lineargs{6}), ...
                str2double(lineargs{8}), ...
                str2double(lineargs{10}), ...
                str2double(lineargs{12}) ];
        elseif (strcmp(lineargs{1}, 'dt'))
            restart.dt = str2double(lineargs{2});
            restart.t = str2double(lineargs{4});
            restart.tmax = str2double(lineargs{6});
        elseif (strcmp(lineargs{1}, 'Walls'))
            % The start of a series of lines which will tell us where the
            % walls are. The next nwalls lines describe walls. 
            restart.nwalls = str2num(lineargs{2});
            i = 0;
            while (i < restart.nwalls)
                line = fgetl(f); ln = ln+1; i = i+1;
                lineargs = strsplit(line);
                restart.walls(i).type = lineargs{1};
                restart.walls(i).normal = [ ...
                        str2double(lineargs{3}), ...
                        str2double(lineargs{4}), ...
                        str2double(lineargs{5}) ];
                restart.walls(i).position = str2double(lineargs{7});
            end
        elseif (strcmp(lineargs{1}, 'Particles'))
            % Particle positions.
            restart.nparticles = str2num(lineargs{2});
            i = 0;
            while (i < restart.nparticles)
                line = fgetl(f); ln = ln+1; i = i+1;
                lineargs = strsplit(line);
                restart.particles(i).pos = [ ...
                    str2double(lineargs{3}), ...
                    str2double(lineargs{4}), ...
                    str2double(lineargs{5}) ];
                restart.particles(i).vel = [ ...
                    str2double(lineargs{6}), ...
                    str2double(lineargs{7}), ...
                    str2double(lineargs{8}) ];
                restart.particles(i).radius = str2double(lineargs{9});
            end
        else
            warning('Could not parse line %d of file %s.', ln, filename);
        end
        line = fgetl(f); ln = ln+1;
    end
    fclose(f);
    toc;
end