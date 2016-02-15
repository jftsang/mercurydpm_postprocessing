%% mercury_load_data - load .data file produced by MercuryDPM
% TODO:
% - At the moment this can only deal with 2D data. Need to be able to deal
% with 3D data as well (and ideally to be able to distinguish between them
% automatically).
% - There is an assumption at the moment that all frame spacings dt are the
% same. This might not be the case in general.
% - It is assumed at the moment that particles are not created or
% destroyed, and that there is the same number of particles in each frame,
% with a given index referring to the same particle in different frames. 

% Notes:
% - The 'dt' found here is the timestep between adjacent entries in the
% .data file. This is usually much larger than the actual timestep that is
% used by the simulation. That smaller timestep size will be stored in the
% .restart file.

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
            particles(j).z(i) = 0; % TODO fix
            particles(j).vx(i) = str2double(line{3});
            particles(j).vy(i) = str2double(line{4});
            particles(j).vz(i) = 0; % TODO fix
            particles(j).radius(i) = str2double(line{5});
        end
    end
    fclose(f);
    
    data.nparts = nparts;
    data.ts = ts;
    data.dt = ts(2) - ts(1); 
    data.particles = particles;
    toc;
end