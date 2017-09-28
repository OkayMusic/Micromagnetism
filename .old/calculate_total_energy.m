function [ energy ] = calculate_total_energy( theta, phi, PARAMS )

vol = size(theta);

E_tot = 0;
for i = 1:vol(1)
    for j = 1:vol(2)
        E_tot = E_tot + localEnergy( theta, phi, i, j, PARAMS);
    end
end
 energy = E_tot;   
end

