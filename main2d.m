close all
gap = 1; from = 1; to = 20;
% BEGIN DEFINING PHYSICAL PARAMETERS
STIFF_CONST = 1;
DM_CONST = 0;
BOUNDARY = 0; % 1 = Periodic, 0 = isolated/thin film
B_FIELD = [0,0,0];
TEMPERATURE = 0.00;
SURF_CONST = 0;
DELTA = pi;

PARAMS = [STIFF_CONST, DM_CONST, BOUNDARY, B_FIELD, TEMPERATURE,...
    SURF_CONST];

[X, Y, Z] = meshgrid(from:gap:to, from:gap:to, 1);
vol = size(X);
theta = pi*rand(vol(1), vol(2));
phi = 2*pi*rand(vol(1), vol(2));

figure

for k=1:1000
  [X_coords, Y_coords] = get_coords(theta, phi);
    for i=1:vol(1)*vol(2)
      a = X_coords(i); b = Y_coords(i);
      [theta(a, b), phi(a, b)] =...
          wiggle(theta, phi, a, b, pi/8*rand, PARAMS);
    end

  makeplot(X, Y, Z, theta, phi)

  if DELTA >  pi * 0.3
      DELTA = DELTA/1.01;
  end
end
close all
% Mx = sin(theta).*cos(phi);
% My = sin(theta).*sin(phi);
% Mz = cos(theta);
% ff = abs(fft(Mz));
% plot(X, ff)
% fieldname = num2str(B_FIELD(3));
% fieldname(2) = ',';
% tempname = num2str(TEMPERATURE);
% tempname(2) = ',';
% the_name = strcat(fieldname,'NO_HISTORY_field',tempname,'temperature');
% saveas(gcf, the_name,'jpg')
% saveas(gcf, the_name)
% B_FIELD(3) = B_FIELD(3) + 0.2;
% end
% TEMPERATURE = TEMPERATURE + 0.01;
% end
