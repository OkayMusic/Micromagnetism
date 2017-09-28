function [X_coords, Y_coords] = get_coords(theta, phi)
vol = size(theta);
unpacker = zeros(vol(1)*vol(2), 1);
temp = zeros(vol(1), vol(2));

if vol(2) ~= 1
  switch randi(2)
  case 1
    temp(2:end-1, :) = abs(diff(theta, 2, 1));
    temp(:, 2:end-1) = abs(diff(theta, 2, 2));
  case 2
    temp(2:end-1, :) = abs(diff(phi, 2, 1));
    temp(:, 2:end-1) = abs(diff(phi, 2, 2));
  end
  temp = temp./( sum(sum(temp))+4/(vol(1)*vol(2)) );
  temp(1,1) = 1/(vol(1)*vol(2)); temp(end, end) = 1/(vol(1)*vol(2));
  temp(1,end) = 1/(vol(1)*vol(2)); temp(end, 1) = 1/(vol(1)*vol(2));
  temp = temp/sum(sum(temp));
end

for ii = 1:vol(2)
  unpacker((ii-1)*vol(1)+1:ii*vol(1)) = temp(:, ii);
end

numbers = [1:vol(1)*vol(2)];

y = randsample(vol(1)*vol(2), vol(1)*vol(2), true, unpacker);

X_coords = ceil(y./vol(1));
Y_coords = changem(mod(y, vol(2)), [vol(2)], [0]);
end
