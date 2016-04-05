%% mercury_load_restart - load a .restart file produced by MercuryDPM
% The .restart file contains such information as the locations of the
% bounding box and of walls and other obstacles, as well as the position
% and velocity of each particle at the end of the simulation, should one
% wish to continue the simulation from that point. 

% TODO 
% - This does not work for all .restart files at the moment, because some
% .restart files contain more information than others. Specifically, the
% lines listing the particle indices have a 'TSP' index in
% twoplanes.restart but not in free_cooling3D.restart, which seems to ruin
% things. 

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
        elseif (strcmp(lineargs{1}, 'Species'))
            % The start of a series of lines which tell us what types of
            % particles there are in this problem.
            restart.nspecies = str2num(lineargs{2});
            i = 0;
            while (i < restart.nspecies)
                line = fgetl(f); ln = ln+1; i = i+1;
                lineargs = strsplit(strtrim(line));
                % Each species line should be of the form 
                % 'word1 val1 word2 val2 word3 val3 ...'
                % TODO - check whether this is true.
                if (mod(length(lineargs),2) ~= 0)
                    warning('Line %d of file %s is a species line with an odd number of fields.',ln,filename);
                end
                for (j = 1:2:(floor(length(lineargs)/2)*2 - 1))
                    if strcmp(lineargs{j}, 'k')
                        restart.species(i).k = str2double(lineargs{j+1});
                    elseif strcmp(lineargs{j}, 'rho')
                        restart.species(i).rho = str2double(lineargs{j+1});
                    else
                        warning('Could not parse field %d in line %d of file %s', ...
                            j,ln,filename);
                    end
                end
            end
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
                
                % The formatting for particle lists in .restart files is
                % variable. There are one or two text fields before the
                % first numerical field, which is where position and
                % velocity data are stored.  We first need to find this
                % first numerical field. 
                
                % TODO - make this more neat and more general
                if(~isnan(str2double(lineargs{2})))
                    firstfield = 2;
                elseif (~isnan(str2double(lineargs{3})))
                    firstfield = 3;
                else
                    firstfield = 4;
                end
                
                restart.particles(i).pos = [ ...
                    str2double(lineargs{firstfield}), ...
                    str2double(lineargs{firstfield+1}), ...
                    str2double(lineargs{firstfield+2}) ];
                restart.particles(i).vel = [ ...
                    str2double(lineargs{firstfield+3}), ...
                    str2double(lineargs{firstfield+4}), ...
                    str2double(lineargs{firstfield+5}) ];
                restart.particles(i).radius = str2double(lineargs{firstfield+6});
                restart.particles(i).species = str2double(lineargs{length(lineargs)});
            end
        else
            warning('Could not parse line %d of file %s.', ln, filename);
        end
        line = fgetl(f); ln = ln+1;
    end
    fclose(f);
    toc;
end