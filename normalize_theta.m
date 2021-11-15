function [theta] = normalize_theta(theta)
% simple normalization of the rotation angle.
while theta > pi
   theta = theta - 2*pi;
end
while theta < -pi
   theta = theta + 2*pi;
end
end