%% Input values
structure_stl = "structure.stl";
print_stl = "print.stl";

% How much to translate the structure
ts = [0 0 0];
% How much to rotate the structure
rs = [-90 0 0];

% How much to translate the print
tp = [0 0 50.8-20];
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
tic
r = 0.1;
x = min(Ps(:,1)):r:max(Ps(:,1));
y = min(Ps(:,2)):r:max(Ps(:,2));
[X,Y] = meshgrid(x,y);

% Need to find better way to do this... gridtrimesh leaves some artifacts
% when there is infinite slope
Z = gridtrimesh(Ts,Ps,X,Y);
figure
hold on
surf(X,Y,Z)
toc
%%
tic
Zs = Z;
for l=1:1
    tic
    Zs(:,:,l) = raise_slice(0.2*l,X,Y,Z,Tp,Pp);
    toc
end
toc
%%
figure
hold on

surf(X,Y,Z)
surf(X,Y,Zs(:,:,1))

hold off
%%
tic

toc