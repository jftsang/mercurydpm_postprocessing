%% mercury_load_data - load .data file produced by MercuryDPM
% TODO:
% - It is assumed that dt is the same from each frame to the next frame. 
%   This might not be the case in general.
% - It is assumed that the bounding box doesn't change between frames.

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
    
    f = fopen(filename);
    i = 0; % Index over frames.
    mode = 0; % mode == 0: header for a timestep; 
              % mode > 0: individual particle data
    ln = 0;
    while (true) 
        line = fgetl(f);
        ln = ln + 1;
        if (line == -1) % end of file
            break; 
        else
            line = strsplit(strtrim(line));
        end
        
        % From the first line, deduce the number of dimensions in this .data
        % file, and get the location of the bounding box.
        if (ln == 1)
            dimensions = (length(line) - 2)/2;
            if (dimensions == 2)
                boundingbox = [str2double(line{3}), str2double(line{5}), ...
                               str2double(line{4}), str2double(line{6}) ];
            elseif (dimensions == 3)
                boundingbox = [str2double(line{3}), str2double(line{6}), ...
                               str2double(line{4}), str2double(line{7}), ...
                               str2double(line{5}), str2double(line{8}) ];
            end
        end

        if (mode == 0)
            % loading a new frame
            i = i + 1;
            % ts - the times of the snapshots
            ts(i) = str2double(line{2});
            frames(i).t = ts(i);
            frames(i).nparts = str2num(line{1});
            if (ts(i) > maxtime) 
                break;
            end
            mode = frames(i).nparts;
        elseif (mode > 0)
            % Have to load 'mode' more particles for this curent timestep.
            mode = mode - 1;
            % j - the individual particle's ID. 
            % Note that the same value of j may correspond to different
            % particles during the course of a simulation, if particles are
            % created or destroyed... there is no guarantee that nparts(i)
            % should be constant. 
            j = frames(i).nparts - mode;
           
            if (dimensions == 2) 
                frames(i).particles(j).pos = [ ...
                    str2double(line{1}), ...
                    str2double(line{2}), ...
                    0];
                frames(i).particles(j).vel = [ ...
                    str2double(line{3}), ...
                    str2double(line{4}), ...
                    0 ];
                frames(i).particles(j).radius = str2double(line{5});
            elseif (dimensions == 3) 
                frames(i).particles(j).pos = [ ...
                    str2double(line{1}), ...
                    str2double(line{2}), ...
                    str2double(line{3}) ];
                frames(i).particles(j).vel = [ ...
                    str2double(line{4}), ...
                    str2double(line{5}), ...
                    str2double(line{6}) ];
                frames(i).particles(j).radius = str2double(line{7});
            else 
                error('dimensions is neither 2 nor 3');        
            end
        end
    end
    fclose(f);
    
    data.filename = filename;
    data.maxtime = maxtime;
    data.dimensions = dimensions;
    data.boundingbox = boundingbox;
    data.ts = ts;
    data.dt = ts(2) - ts(1); 
    data.frames = frames;
    toc;
end
