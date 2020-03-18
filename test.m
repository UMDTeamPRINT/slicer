%% Input values
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

%% Display structure
[Ps,Ts,Ns]=import_stl_fast(structure_stl,1);

[Ps, Ns] = rotate_mesh(Ps,Ns,rs,deg);
Ps = translate_mesh(Ps,ts);

patch('Faces', Ts, 'Vertices', Ps, 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
view(3)
axis equal
zlabel('Z');xlabel('X');ylabel('Y');

%% Display Print in structure
[Pp,Tp,Np]=import_stl_fast(print_stl,1);

[Pp,Np] = rotate_mesh(Pp,Np,rp,deg);
Pp = translate_mesh(Pp,tp);

patch('Faces', Tp, 'Vertices', Pp, 'FaceVertexCData', (1:length(Tp(:,1)))', 'FaceColor', 'flat');

%%
nx = 200;
ny = 200;
x = linspace(min(Ps(:,1)),max(Ps(:,1)),nx);
y = linspace(min(Ps(:,2)),max(Ps(:,2)),ny);
[X,Y] = meshgrid(x,y);
Z = gridtrimesh(Ts,Ps,X,Y);
figure
hold on
surf(X,Y,Z)
%%
% See [1]Bin Huang, “Development of a Software procedure for Curved layered Fused DepositionModelling (CLFDM),” Master Thesis, Auckland University of Technology, 2009.
% Implementation of MFVCP
t = 1;
V3 = [1 0 0];
O = [0 0 0];
for j=1:ny
    for i=2:nx-1
        V1 = [X(i-1,j) Y(i-1,j) Z(i-1,j)] - [X(i,j) Y(i,j) Z(i,j)];
        V2 = [X(i+1,j) Y(i+1,j) Z(i+1,j)] - [X(i,j) Y(i,j) Z(i,j)];
        V13 = t.*cross(V1,V3)./norm(cross(V1,V3));
        V23 = t.*cross(V3,V2)./norm(cross(V3,V2));
        alpha = acos(dot(V13,V23)./(norm(V13)*norm(V23)));
        V5 = t.*(V13+V23)./(cos(alpha/2)*norm(V13+V23));
        P2 = [X(i,j) Y(i,j) Z(i,j)] + V5;
        if ~isnan(P2)
            O = [O; P2];
        end
    end
end
O = O(2:length(O(:,1)'),:);
Z2 = griddata(O(:,1),O(:,2),O(:,3),X,Y);
figure
hold on
surf(X,Y,Z2)
surf(X,Y,Z)
hold off