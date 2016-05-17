function ml_plotvelprofile2d(fn)
    % First run ml_gridveldata.
    [yqq,zqq,rhoqq,vxqq,vyqq,vzqq,Tqq,pqq] = ml_gridveldata(fn);
    
    colormap jet;
    
    subplot(4,2,1);
    mesh(yqq, zqq, rhoqq); colorbar; view(2); 
    axis equal; axis([-1 1 0 0.5]);
    title('rho (unscaled)');
    caxis([0 18]);

    subplot(4,2,3);
    mesh(yqq, zqq, vxqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]); 
    title('vx');
    caxis([0 4]);
    
    subplot(4,2,5);
    mesh(yqq, zqq, vyqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]); 
    caxis([-0.3 0.3]);
    title('vy');
    
    subplot(4,2,7);
    mesh(yqq, zqq, vzqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]); 
    caxis([-0.3 0.3]);
    title('vz');
    
    subplot(4,2,2);
    mesh(yqq, zqq, Tqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]);
    title('T (unscaled)');
    
    subplot(4,2,4)
    mesh(yqq, zqq, pqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]);
    title('pressure (unscaled, approx)');

    subplot(4,2,6)
    [Gy,Gz] = gradient(vxqq, yqq(1,2)-yqq(1,1), zqq(2,1)-zqq(1,1));
    shearrateqq = sqrt(Gy.^2 + Gz.^2);
    mesh(yqq, zqq, shearrateqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]);
    title('shear rate (approx)');
    caxis([0 25]);
    
    subplot(4,2,8)
    inertialnumberqq = shearrateqq ./ sqrt(pqq);
    mesh(yqq, zqq, inertialnumberqq); colorbar; view(2);
    axis equal; axis([-1 1 0 0.5]);
    caxis([0 50]);
    title('Inertial number (unscaled, approx)');

end