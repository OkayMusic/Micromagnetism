function makeplot(X, Y, Z, theta, phi)
Mx = sin(theta).*cos(phi);
My = sin(theta).*sin(phi);
Mz = cos(theta);

% surf(X, Y, Mz,'EdgeColor','none','LineStyle','none','FaceColor','interp')
alpha(0.5)

M = cat(3,Mx, My, Mz);

% hold on

qui = quiver3(X, Y,Z, Mx, My, Mz);

qui.Color = 'black';
qui.LineStyle = '-';
qui.LineWidth = 1.5;
qui.ShowArrowHead = 'on';
qui.MaxHeadSize = 100;
qui.AutoScale = 'on';
qui.AutoScaleFactor = 1.2;
qui.AlignVertexCenters = 'on';

daspect([1,1,1])
set(gcf, 'Position', get(0, 'Screensize'));
view(0, 90)
caxis([-1,1])

view([1,1,1])

% hold off
view(0, 90)

pause(0.000000001)

end
