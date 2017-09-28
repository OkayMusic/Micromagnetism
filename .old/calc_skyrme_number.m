function [N_Skyrme] = calc_skyrme_number(theta, phi)
% Calculates topological winding number for a 2D surface

Mx = sin(theta).*cos(phi);
My = sin(theta).*sin(phi);
Mz = cos(theta);
gap = 1;

M = cat(3, Mx, My, Mz);

dM_dx(:,:,1) = diff(Mx')'./gap;
dM_dx(:,:,2) = diff(My')'./gap;
dM_dx(:,:,3) = diff(Mz')'./gap;
dM_dy(:,:,1) = diff(Mx)./gap;
dM_dy(:,:,2) = diff(My)./gap;
dM_dy(:,:,3) = diff(Mz)./gap;

crossed_field = cross(dM_dy(:,1:vol(2)-1,:), dM_dx(1:vol(1)-1,:,:), 3);
integrand = dot(M(1:vol(1)-1,1:vol(2)-1, :), crossed_field, 3);
N_Skyrme = gap^2*sum(sum(integrand))/(4*pi);
end
