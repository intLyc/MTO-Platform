function [obj, con] = APKACP_Objective(x, angularRange, armLength)
% Planar-arm endpoint distance, KR-AMTEA Eq. (22); same kinematics as PKACP.
d = size(x, 2);
% Convert decisions to joint angles and accumulate them into segment orientations.
angle = cumsum((x - 0.5) * (2 * pi * angularRange / d), 2);
% Use equal segment lengths and minimize endpoint distance to (0.5, 0.5).
endpoint = armLength / d * [sum(cos(angle), 2), sum(sin(angle), 2)];
obj = sqrt(sum((endpoint - [0.5, 0.5]).^2, 2));
con = zeros(size(x, 1), 1);
end
