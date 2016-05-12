%% mercury_load_ene - load .ene file produced by MercuryDPM

function ene = mercury_load_ene(filename, maxtime)
    tic;
    if nargin < 2
        maxtime = Inf;
    end

    ene.filename = filename;
    f = fopen(filename);
    fgetl(f); % read and discard the first line, which is merely a header
    i = 0; % Index over frames.
    while (true) 
        line = fgetl(f);
        if (line == -1)
            break;
        else
            i = i+1;
            line = strsplit(line);
            line = str2double(line(2:end));
            ts(i) = line(1);
            ene_gra(i) = line(2);
            ene_kin(i) = line(3);
            ene_rot(i) = line(4);
            ene_ela(i) = line(5);
        end
        
    end
    fclose(f);
    
    ene.ts = ts;
    ene.ene_gra = ene_gra;
    ene.ene_kin = ene_kin;
    ene.ene_rot = ene_rot;
    ene.ene_ela = ene_ela;
    toc;
end