%% mercury_draw_frame - draw particle positions from a .data file 
% (as obtained from mercury_load_data).
% 
% This may be ill-advised if there are many particles or if you ask for
% many frames. 

function mercury_draw_frames(data, frames, vels, spheres, holdyn) 
    % By default, we don't draw spheres or velocity vectors.
    % This function is really meant for drawing particle path histories,
    % and is meant to be used when the number of particles is fairly small.
    % Consider using mercury_draw_restart when there are many particles.
    if nargin < 5
        holdyn = 0;
    end
    if nargin < 4
        spheres = 0;
    end
    if nargin < 3
        vels = 0;
    end
    if nargin < 2
        frames = [1];
    end
    tic;
    
    for frame = frames
        % draw particle positions
        for i = 1:length(data.particles)
            if (data.dimensions == 2)
                plot(data.particles(i).pos(frame,1), ...
                     data.particles(i).pos(frame,2), 'k.');
            elseif (data.dimensions == 3)
                plot3(data.particles(i).pos(frame,1), ...
                      data.particles(i).pos(frame,2), ...
                      data.particles(i).pos(frame,3), 'k.');
            end
            hold on;
            
            % Drawing spheres for the particles
            % This may be costly...
            
            if (spheres)
                if (data.dimensions == 2)
                    thetas = 0:pi/8:2*pi;
                    plot(data.particles(i).pos(frame,1) + data.particles(i).radius(frame) * cos(thetas), ...
                         data.particles(i).pos(frame,2) + data.particles(i).radius(frame) * sin(thetas), ...
                         'k-');
                elseif (data.dimensions == 3)
                    [thetas,phis] = meshgrid(0:pi/8:pi,0:pi/8:2*pi);
                    mesh(...
                        data.particles(i).pos(frame,1) + data.particles(i).radius(frame) * sin(thetas).*cos(phis),...
                        data.particles(i).pos(frame,2) + data.particles(i).radius(frame) * sin(thetas).*sin(phis),...
                        data.particles(i).pos(frame,3) + data.particles(i).radius(frame) * cos(thetas) );
                end
            end
        end
        axis(data.boundingbox);
        axis equal;
        xlabel('x');
        ylabel('y');
        if (data.dimensions == 3)
            zlabel('z');
        end
        toc;

        if (vels)
            % draw particle velocities
            % TODO:
            % - This only works for 2D data at the moment. 
            % - velocity arrows need to be scaled sensibly. How to do that?

            % For drawing velocity arrows. 
            % See http://stackoverflow.com/questions/25729784/how-to-draw-an-arrow-in-matlab
            drawArrow = @(x,y,u,v) quiver(x, y, u, v, 0, 'Color', 'k');
            for i = 1:length(data.particles)
                drawArrow(data.particles(i).pos(frame,1), data.particles(i).pos(frame,2), ...
                          data.particles(i).vel(frame,1) * data.dt, data.particles(i).vel(frame,2) * data.dt);
            end
        end
    end
    
    if (holdyn)
        hold on;
    else
        hold off;
    end
    toc;
end