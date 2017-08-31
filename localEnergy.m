function [energy] = localEnergy(theta, phi, a, b, PARAMS)
% calculates the energy change due to local effects after flipping a spin
% theta and phi

STIFF_CONST = PARAMS(1);
DM_CONST = PARAMS(2);
BOUNDARY = PARAMS(3);
B_FIELD = PARAMS(4:6);
SURF_CONST = PARAMS(7);
vol = size(theta);

energy = E_Zee(a,b) + E_surf(a, b);

switch BOUNDARY
    case 0
        if a ~= 1
            energy = energy + E_exchange(a,b,a-1,b) + E_DM(a,b,a-1,b);
        end
        if a ~= vol(1)
            energy = energy + E_exchange(a+1,b,a,b) + E_DM(a+1,b,a,b);
        end
        if b ~= 1
            energy = energy + E_exchange(a,b,a,b-1) + E_DM(a,b,a,b-1);
        end
        if b ~= vol(2)
            energy = energy + E_exchange(a,b+1,a,b) + E_DM(a,b+1,a,b);
        end
    case 1
        if a ~= 1
            energy = energy+E_exchange(a,b,a-1,b)+E_DM(a,b,a-1,b);
        else
            energy = energy+E_exchange(a,b,vol(1),b)+E_DM(a,b,vol(1),b);
        end
        if b ~= 1
            energy = energy+E_exchange(a,b,a,b-1)+E_DM(a,b,a,b-1);
        else
            energy = energy+E_exchange(a,b,a,vol(2))+E_DM(a,b,a,vol(2));
        end
end

% The following functions calculate the energy due to various interactions
% Currently included are: Exchange interaction, DM interaction + Zeeman

% Here [l,m] define the direction in which derivatives are being taken.
% E.g. choosing hk = ab, lm = a+1, b => derivatives in +ve y direction only
% This is so it can still work with spins on the edge of the grid
    function [Exchange_term] = E_exchange(h,k,l,m)
        Exchange_term = STIFF_CONST * ...
            ((cos(phi(h,k))*sin(theta(h,k))-cos(phi(l,m))*sin(theta(l,m)))^2+...
            (sin(phi(h,k))*sin(theta(h,k))-sin(phi(l,m))*sin(theta(l,m)))^2+...
            (cos(theta(h,k)) - cos(theta(l,m)))^2);
    end

    function [DM_energy] = E_DM(h,k,l,m)
        DM_energy = DM_CONST * dot(...
            [cos(phi(h,k))*sin(theta(h,k)),sin(phi(h,k))*sin(theta(h,k))...
            ,cos(theta(h,k))],...
            [cos(theta(h,k)) - cos(theta(l,k)),...
            -cos(theta(h,k)) + cos(theta(h,m)),...
            sin(phi(h,k))* sin(theta(h,k))-sin(phi(h,m))*sin(theta(h,m))-...
            cos(phi(h,k))*sin(theta(h,k))+cos(phi(l,k))*sin(theta(l,k))]);
    end

    function [Zeeman_energy] = E_Zee(h,k)
        Zeeman_energy = dot(B_FIELD,...
            [cos(phi(h,k))*sin(theta(h,k)),...
            sin(phi(h,k))* sin(theta(h,k)),...
            cos(theta(h,k))]);
    end

    function [Surface_anisotropy_energy] = E_surf(h, k)
        Surface_anisotropy_energy = SURF_CONST *...
            (sin(theta(h,k)*cos(phi(h,k))))^2;
    end

end
