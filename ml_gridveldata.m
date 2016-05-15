function [yqq,zqq,vxqq,vyqq,vzqq] = ml_gridveldata(fn)
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
    rhoqq(rhoqq==0) = nan; % so that regions of zero density aren't painted
    [yqq, zqq, vxqq] = griddata(yqs, zqs, vxqs, yqq, zqq);
    [yqq, zqq, vyqq] = griddata(yqs, zqs, vyqs, yqq, zqq);
    [yqq, zqq, vzqq] = griddata(yqs, zqs, vzqs, yqq, zqq);
end