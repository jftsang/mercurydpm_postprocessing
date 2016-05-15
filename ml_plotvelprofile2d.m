function ml_plotvelprofile2d(fn)
    % First run ml_gridveldata.
%     [yqq,zqq,vxqq,vyqq,vzqq] = ml_gridveldata(fn);
    
    colormap jet;
    
    %{
    subplot(2,2,1);
    mesh(yqq, zqq, rhoqq); colorbar; view(2); 
    axis equal; axis([-1 1 0 0.5]); 

    subplot(2,2,2);
    %}
    subplot(2,1,1);
    mesh(yqq, zqq, vxqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]); 
    
    %{
    subplot(2,2,3);
    mesh(yqq, zqq, vyqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]); 
    caxis([-0.3 0.3]);
    
    subplot(2,2,4);
    mesh(yqq, zqq, vzqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]); 
    caxis([-0.3 0.3]);
    %}
    
    subplot(2,1,2);
    streamline(yqq, zqq, vyqq, vzqq, [0 0 0 0], [0 0.1 0.2 0.3]);
    grid; axis equal; axis([-1 1 0 0.5]);
   
end