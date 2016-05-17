function [yqq,zqq,rhoqq,vxqq,vyqq,vzqq,Tqq,pqq] = ml_gridveldata(fn)
    out = importdata(fn);
    yqs = out.data(:,3);
    zqs = out.data(:,4);
    rhoqs = out.data(:,5);
    vxqs = out.data(:,6);
    vyqs = out.data(:,7);
    vzqs = out.data(:,8);
    Tqs = out.data(:,12);
    pqs = out.data(:,13);
    
    [yqq, zqq] = meshgrid( ...
        linspace(min(yqs), max(yqs), 128), ...
        linspace(min(zqs), max(zqs), 128) );
    [yqq, zqq, rhoqq] = griddata(yqs, zqs, rhoqs, yqq, zqq);
    rhoqq(rhoqq < 1) = nan; % so that regions of zero density aren't painted
    [yqq, zqq, vxqq] = griddata(yqs, zqs, vxqs, yqq, zqq);
    [yqq, zqq, vyqq] = griddata(yqs, zqs, vyqs, yqq, zqq);
    [yqq, zqq, vzqq] = griddata(yqs, zqs, vzqs, yqq, zqq);
    vxqq(isnan(rhoqq)) = nan;
    vyqq(isnan(rhoqq)) = nan;
    vzqq(isnan(rhoqq)) = nan;
    [yqq, zqq, Tqq] = griddata(yqs, zqs, Tqs, yqq, zqq);
    Tqq(isnan(rhoqq)) = nan;

    [yqq, zqq, pqq] = griddata(yqs, zqs, pqs, yqq, zqq);
    pqq(isnan(rhoqq)) = nan;
    pqq(pqq<0) = nan;
end