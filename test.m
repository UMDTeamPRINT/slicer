[P,T,N]=import_stl_fast("structure.stl",1);

[P, N] = rotate_mesh(P,N,[-90 0 0],1);
P = translate_mesh(P,[0 0 0]);

patch('Faces', T, 'Vertices', P, 'FaceVertexCData', (1:length(T(:,1)))', 'FaceColor', 'flat');
view(3)
axis equal
zlabel('Z');xlabel('X');ylabel('Y');