gap = 1; from = 0; to = 10;
% BEGIN DEFINING PHYSICAL PARAMETERS
STIFF_CONST = 1;
DM_CONST = 2;
BOUNDARY = 0; % 1 = Periodic, 0 = isolated/thin film
B_FIELD = [0,0,0];
TEMPERATURE = 0.00;
SURF_CONST = 1;

PARAMS = [STIFF_CONST, DM_CONST, BOUNDARY, B_FIELD, TEMPERATURE,...
    SURF_CONST];

[X, Y, Z] = meshgrid(from:gap:to, 1,1);
vol = size(X);

close all

DELTA = pi;
figure

% for temp = 1:20
theta = pi*rand(vol(1), vol(2));
phi = 2*pi*rand(vol(1), vol(2));
%     B_FIELD = [0,0,0];
    PARAMS = [STIFF_CONST, DM_CONST, BOUNDARY, B_FIELD, TEMPERATURE];
% for field = 1:15

for k=1:1000
for i=1:vol(1)
    for j=1:vol(2)
        a = randi(vol(1)); b = randi(vol(2));
        [theta(a, b), phi(a, b)] =...
            wiggle(theta, phi, a, b, pi/8*rand, PARAMS);
    end
end

makeplot(X, Y, Z, theta, phi)

if DELTA >  pi * 0.3
    DELTA = DELTA/1.01;
end
end
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
