%% mercury_load_data - load .data file produced by MercuryDPM
% TODO:
% - At the moment this can only deal with 2D data. Need to be able to deal
% with 3D data as well (and ideally to be able to distinguish between them
% automatically).

function data = mercury_load_data(filename, maxtime)
    tic;
    if nargin < 2
        maxtime = Inf;
    end
    
    data.filename = filename;
    f = fopen(filename);
    i = 0; % Index over frames.
    mode = 0; % mode == 0: header for a timestep; 
              % mode > 0: individual particle data
    while (true) 
        line = fgetl(f);
        if (line == -1)
            break;
        else
            line = strsplit(line);
        end
        if (mode == 0)
            % loading a new timestep
            i = i + 1;
            nparts(i) = str2num(line{1});
            % ts - the times of the snapshots
            ts(i) = str2double(line{2});
            if (ts(i) > maxtime) 
                break;
            end
            mode = nparts(i);
        elseif (mode > 0)
            % Have to load 'mode' more particles for this curent timestep.
            mode = mode - 1;
            % j - the individual particle's ID. 
            % Note that the same value of j may correspond to different
            % particles during the course of a simulation, if particles are
            % created or destroyed... there is no guarantee that nparts(i)
            % should be constant. 
            j = nparts(i) - mode;
            
            particles(j).x(i) = str2double(line{1});
            particles(j).y(i) = str2double(line{2});
            particles(j).vx(i) = str2double(line{3});
            particles(j).vy(i) = str2double(line{4});
            particles(j).radius(i) = str2double(line{5});
        end
    end
    fclose(f);
    
    data.nparts = nparts;
    data.ts = ts;
    data.particles = particles;
    toc;
end