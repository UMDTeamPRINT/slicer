[P,T,N]=stlread("structure.stl",1);

patch('Faces', T, 'Vertices', P, 'FaceVertexCData', (1:length(T(:,1)))', 'FaceColor', 'flat');
view(3)
axis equal