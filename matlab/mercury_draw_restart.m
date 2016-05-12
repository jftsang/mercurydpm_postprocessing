%% mercury_draw_restart - draw particle positions and velocities from a .restart file
% A .restart file also contains information about the bounding box and
% walls, although it does not contain any information about particle
% histories.

function mercury_draw_restart(restart) 
    tic;
    % Particle positions
    if (restart.nparticles > 0)
        for (i = 1:length(restart.particles)) 
            plot3(...
                restart.particles(i).pos(1), ...
                restart.particles(i).pos(2), ...
                restart.particles(i).pos(3), 'k.');
            hold on;
            % Drawing spheres for the particles
            % This may be costly...
            draw_sphere(restart.particles(i).pos, restart.particles(i).radius);
        end

        % Particle velocities
        % TODO - velocity arrows need to be scaled sensibly. How to do that?
        for (i = 1:length(restart.particles))
            quiver3(...
                restart.particles(i).pos(1), ...
                restart.particles(i).pos(2), ...
                restart.particles(i).pos(3), ...
                restart.particles(i).vel(1) * restart.dt, ...
                restart.particles(i).vel(2) * restart.dt, ...
                restart.particles(i).vel(3) * restart.dt, ...
                0, 'Color', 'k' );
        end
    end
    
    % Walls
    if (restart.nwalls > 0)
        for (i = 1:length(restart.walls)) 
            draw_wall(restart.walls(i).normal, restart.walls(i).position, restart.boundingbox);
        end
    end
    
    % Bounding box
    
    axis equal;
    axis(restart.boundingbox);
    
    title(restart.name);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold off;
    toc;
end

function draw_sphere(pos, radius)
    % TODO:
    % - support for drawing sphere with different orientations
    % - support for drawing spheres with different resolutions  
    [thetas,phis] = meshgrid(0:pi/8:pi,0:pi/8:2*pi);
    mesh(...
        pos(1) + radius * sin(thetas).*cos(phis),...
        pos(2) + radius * sin(thetas).*sin(phis),...
        pos(3) + radius * cos(thetas) );
end

function draw_wall(normal, position, boundingbox) 
    if (norm(normal) == 0)
        error('normal has norm zero');
    end
    normal = normal / norm(normal);

%     x = -10:1:10; % This works, provided that [xmin,xmax], etc are all contained in [-10,10].
                    % One should make this more general.
    x = linspace(min(boundingbox),max(boundingbox),3); % Better?
    
    % TODO - It is a sin to compare floating point numbers like this.
    % Better to determine the direction in which the normal is greatest,
    % rather than simply going for where it is nonzero! 
    if (normal(3) ~= 0)
        [X,Y] = meshgrid(x);
        Z = (position - normal(1)*X - normal(2)*Y)/normal(3);
    elseif (normal(2) ~= 0)
        [X,Z] = meshgrid(x);
        Y = (position - normal(1)*X - normal(3)*Z)/normal(2);
    elseif (normal(1) ~= 0)
        [Y,Z] = meshgrid(x);
        X = (position - normal(2)*Y - normal(3)*Z)/normal(1);
    end
    surf(X,Y,Z);
end