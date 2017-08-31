function [theta_final, phi_final] = wiggle(theta, phi,i,j, DELTA, PARAMS)
% wiggles the i, j'th spin in a random direction by DELTA. If the wiggled 
% configuration has lower energy, keep it.

TEMPERATURE = PARAMS(7);
random_int = randi(4);
DELTA = DELTA * rand;

% properties before wiggling
E_0 = localEnergy(theta, phi, i, j, PARAMS); 
theta_0 = theta(i, j);
phi_0 = phi(i, j);

if rand > TEMPERATURE
    switch random_int
        case 1
            theta(i, j) = theta(i, j) + DELTA;
            E_new = localEnergy(theta, phi, i, j, PARAMS);
        case 2
            theta(i, j) = theta(i,j) - DELTA;
            E_new = localEnergy(theta, phi, i, j, PARAMS);
        case 3
            phi(i,j) = phi(i,j) + DELTA;
            E_new = localEnergy(theta, phi, i, j, PARAMS);
        case 4
            phi(i,j) = phi(i,j) - DELTA;
            E_new = localEnergy(theta, phi, i, j, PARAMS);
    end
    if E_new < E_0 
        theta_final = theta(i, j);
        phi_final = phi(i, j);
    else    
        theta_final = theta_0;
        phi_final = phi_0;
    end
else
    switch random_int
        case 1
            theta_final = theta_0 + DELTA;
            phi_final = phi_0;
        case 2
            theta_final = theta_0 - DELTA;
            phi_final = phi_0;
        case 3
            theta_final = theta_0;
            phi_final = phi_0 + DELTA;
        case 4
            theta_final = theta_0;
            phi_final = phi_0 - DELTA;
    end
end
end