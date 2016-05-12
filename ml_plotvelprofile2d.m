function ml_plotvelprofile2d(fn)
    out = importdata(fn);
    yqs = out.data(:,3);
    zqs = out.data(:,4);
    rhoqs = out.data(:,5);
    vxqs = out.data(:,6);
    vyqs = out.data(:,7);
    vzqs = out.data(:,8);
    
    [yqq, zqq] = meshgrid( ...
        linspace(min(yqs), max(yqs), 128), ...
        linspace(min(zqs), max(zqs), 128) );
    [yqq, zqq, rhoqq] = griddata(yqs, zqs, rhoqs, yqq, zqq);
    [yqq, zqq, vxqq] = griddata(yqs, zqs, vxqs, yqq, zqq);
    
    subplot(2,1,1);
    mesh(yqq, zqq, rhoqq); colorbar; view(2);
    subplot(2,1,2);
    mesh(yqq, zqq, vxqq); colorbar; view(2);
end