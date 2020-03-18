function P=translate_mesh(P,v)
% Simple function that translates mesh by specified distances in each
% direction.
%--------------------------------------------------------------
% Inputs/Outputs:
%   P = Points (or vertices) of faces
%--------------------------------------------------------------
    P = bsxfun(@plus,P,v);
end