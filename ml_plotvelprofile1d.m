function ml_plotvelprofile1d(fn)
    out = importdata(fn);
    zqs = out.data(:,4);
    rhoqs = out.data(:,5);
    vxqs = out.data(:,6);
    vyqs = out.data(:,7);
    vzqs = out.data(:,8);
    subplot(2,1,1);
    plot(rhoqs, zqs, 'k');
    title('centreline, density');
    subplot(2,3,4);
    plot(vxqs, zqs, 'k');
    title('centreline, velocity');
    bagnold = @(b,z) b(1)*(1 - (1-z/b(2)).^(3/2)) + b(3);
    b = nlinfit(zqs,vxqs,bagnold,[1,1,0])
    hold on; plot(bagnold(b,zqs), zqs, 'k--'); hold off;
    subplot(2,3,5);
    plot(vyqs, zqs, 'k');
    subplot(2,3,6);
    plot(vzqs, zqs, 'k');
end