function [P,N]=rotate_mesh(P,N,v,deg)
% Rotates mesh specifed angles around respective axises
%--------------------------------------------------------------
% Inputs/Output:
%   P = Points (or vertices) of the triangles
%   N = Normal vectors of each face
%--------------------------------------------------------------

if deg==1
    v=v*(pi/180);
end

rx = v(1);
ry = v(2);
rz = v(3);
Rx = [1,0,0;
    0,cos(rx),-sin(rx);
    0,sin(rx),cos(rx);];
Ry = [cos(ry),0,sin(ry);
    0,1,0;
    -sin(ry),0,cos(ry);];
Rz = [cos(rz),-sin(rz),0;
    sin(rz),cos(rz),0;
    0,0,1;];
R=Rz*Ry*Rx;

P=P*R;
N=N*R;

end