%% mercury_draw_restart - draw particle positions and velocities from a .restart file
% A .restart file also contains information about the bounding box and
% walls, although it does not contain any information about particle
% histories.

function mercury_draw_restart(restart) 
    tic;
    % Particle positions
    for (i = 1:length(restart.particles)) 
        plot3(...
            restart.particles(i).pos(1), ...
            restart.particles(i).pos(2), ...
            restart.particles(i).pos(3), 'k.');
        hold on;
        % Drawing spheres for the particles
        % This may be costly...
        [thetas,phis] = meshgrid(0:pi/8:pi,0:pi/8:2*pi); 
        surf(...
            restart.particles(i).pos(1) + restart.particles(i).radius * sin(thetas).*cos(phis),...
            restart.particles(i).pos(2) + restart.particles(i).radius * sin(thetas).*sin(phis),...
            restart.particles(i).pos(3) + restart.particles(i).radius * cos(thetas) );
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
    
    % Walls
    for (i = 1:length(restart.walls)) 
        draw_wall(restart.walls(i).normal, restart.walls(i).position);
    end
    
    % Bounding box
    axis(restart.boundingbox);
    
    title(restart.name);
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold off;
    toc;
end

function draw_wall(normal, position) 
    normal = normal / norm(normal);
    x = -10:1:10; % TODO - this works, provided that [xmin,xmax], etc are all contained in [-10,10].
                  % Make this more general.
    if (normal(3) ~= 0)
        [X,Y] = meshgrid(x);
        Z = (position - normal(1)*X - normal(2)*Y)/normal(3);
    elseif (normal(2) ~= 0)
        [X,Z] = meshgrid(x);
        Y = (position - normal(1)*X - normal(3)*Z)/normal(2);
    elseif (normal(1) ~= 0)
        [Y,Z] = meshgrid(x);
        X = (position - normal(2)*Y - normal(3)*Z)/normal(1);
    else
        error('normal has norm zero');
    end
    surf(X,Y,Z);
end