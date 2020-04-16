%% Input values
structure_stl = "structure.stl";
print_stl = "print.stl";

% How much to translate the structure
ts = [0 0 0];
% How much to rotate the structure
rs = [-90 0 0];

% How much to translate the print
tp = [0 0 50.8-22];
% How much to rotate the print
rp = [-90 0 0];

% 1 means all inputs are in degrees
deg = 1;

% resolution in X,Y
r = 0.2;

% layer height
lh = 0.2;

%% Import STLs
% Structure
[Ps,Ts,Ns]=import_stl_fast(structure_stl,1);

[Ps, Ns] = rotate_mesh(Ps,Ns,rs,deg);
Ps = translate_mesh(Ps,ts);

% Print
[Pp,Tp,Np]=import_stl_fast(print_stl,1);

[Pp,Np] = rotate_mesh(Pp,Np,rp,deg);
Pp = translate_mesh(Pp,tp);

%% Display models
% figure
% hold on
% patch('Faces', Ts, 'Vertices', Ps, 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
% view(3)
% axis equal
% zlabel('Z');xlabel('X');ylabel('Y');
% patch('Faces', Tp, 'Vertices', Pp, 'FaceVertexCData', (1:length(Tp(:,1)))', 'FaceColor', 'flat');
% hold off

%% Test Code
Ppl = mean_raise(10,Ts,Ps,Ns);
patch('Faces', Ts, 'Vertices', Ps, 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
hold on
m2 = patch('Faces', Ts, 'Vertices', Ppl, 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
m2.FaceAlpha='flat';
m2.FaceVertexAlphaData=(0.3);

%% Generate Layers
% Number of layers
l=100;
Ppl=zeros(size(Ps,1),3,l);
tic
for i=1:100
    Ppl(:,:,i)=mean_raise(i*lh,Ts,Ps,Ns);
    patch('Faces', Ts, 'Vertices', Ppl(:,:,i), 'FaceVertexCData', (1:length(Ts(:,1)))', 'FaceColor', 'flat');
    hold on
    i
    toc
end
alpha(0.3);
toc