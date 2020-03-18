structure_stl = "structure.stl";
print_stl = "print.stl";

% How much to translate the structure
ts = [0 0 0];
% How much to rotate the structure
rs = [-90 0 0];

% How much to translate the print
tp = [0 0 50.8-19.04];
% How much to rotate the print
rp = [-90 0 0];

% 1 means all inputs are in degrees
deg = 1;

[Ps,Ts,Ns]=import_stl_fast(structure_stl,1);

[Ps, Ns] = rotate_mesh(Ps,Ns,rs,deg);
Ps = translate_mesh(Ps,ts);

patch('Faces', Ts, 'Vertices', Ps, 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
view(3)
axis equal
zlabel('Z');xlabel('X');ylabel('Y');

[Pp,Tp,Np]=import_stl_fast(print_stl,1);

[Pp,Np] = rotate_mesh(Pp,Np,rp,deg);
Pp = translate_mesh(Pp,tp);

patch('Faces', Tp, 'Vertices', Pp, 'FaceVertexCData', (1:length(Tp(:,1)))', 'FaceColor', 'flat');

% See [1]Bin Huang, “Development of a Software procedure for Curved layered Fused DepositionModelling (CLFDM),” Master Thesis, Auckland University of Technology, 2009.
% Implementation of MFVCP
% lPs = length(Ps(:,1))
% V1 = Ps(1:lPs-2,1:3)-Ps(2:lPs-1,1:3)
% V2 = Ps(3:lPs,1:3)-Ps(2:lPs-1,1:3)
% V3 = repmat([0 1 0],length(V2(:,1)),1)
% cV13 = cross(V1,V3)
% cV32 = cross(V3,V2)
% t=5
% V13 = t*(cV13./(vecnorm(cV13')'))
% V23 = t*(cV32./(vecnorm(cV32')'))
% dot(V13,V23,2)
% alpha = acos(dot(V13,V23,2)./(vecnorm(V13')'.*vecnorm(V23')'))
% V5 = t*(V13+V23)./(cos(alpha/2).*(vecnorm(V13')'.*vecnorm(V23')'))
% Ps2 = V5+Ps(2:lPs-1,:)
% patch('Faces', Ts, 'Vertices', Ps, 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
% view(3)
% axis equal
% zlabel('Z');xlabel('X');ylabel('Y');
% hold on
% scatter3(Ps2(:,1),Ps2(:,2),Ps2(:,3))
