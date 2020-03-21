function Z2 = raise_slice(t,X,Y,Z,T,P)
%% TODO make this better
%% Raises slice by t
% See [1]Bin Huang, “Development of a Software procedure for Curved layered Fused DepositionModelling (CLFDM),” Master Thesis, Auckland University of Technology, 2009.
% Implementation of FVCP
%% Init variables
% dimensions of surface indices
nx = size(X,2);
ny = size(Y,1);

% Create output matrix
O = zeros(nx*ny,7);

% Index of current value in output matrix
in = 1;

for j=2:ny-1
    for i=2:nx-1
        Pi = [X(i,j) Y(i,j) Z(i,j)];
        Pi_minus_1 = [X(i-1,j) Y(i-1,j) Z(i-1,j)];
        Pi_plus_1 = [X(i+1,j) Y(i+1,j) Z(i+1,j)]; 
        Pj_minus_1 = [X(i,j-1) Y(i,j-1) Z(i,j-1)];
        Pj_plus_1 = [X(i,j+1) Y(i,j+1) Z(i,j+1)];
        
      	K1i = (Pi(3)-Pi_minus_1(3))/(Pi(2)-Pi_minus_1(2));
        K2i = (Pi_plus_1(3)-Pi(3))/(Pi_plus_1(2)-Pi(2));
        K1j = (Pi(3)-Pj_minus_1(3))/(Pi(1)-Pj_minus_1(1));
        K2j = (Pj_plus_1(3)-Pi(3))/(Pj_plus_1(1)-Pi(1));
        
        V1 = Pi_minus_1 - Pi;
        V2 = Pi_plus_1 - Pi;
        V3 = Pj_plus_1 - Pi;
        V4 = Pj_minus_1 - Pi;
        
        cV13 = -cross(V3,V1);
        V13 = t*cV13/norm(cV13);
        
        cV14 = -cross(V1,V4);
        V14 = t*cV14/norm(cV14);
        
        cV23 = cross(V3,V2);
        V23 = t*cV23/norm(cV23);
        
        cV24 = cross(V2,V4);
        V24 = t*cV24/norm(cV24);
        
        alpha1 = acos(dot(V13,V14)/norm(dot(V13,V14)));
        V1314 = t*(V13+V14)/(norm(V13+V14)*cos(alpha1/2));
        
        alpha2 = acos(dot(V23,V24)/norm(dot(V23,V24)));
        V2324 = t*(V23+V24)/(norm(V23+V24)*cos(alpha2/2));
        
        beta = acos(dot(V1314,V2324)/(norm(dot(V1314,V2324))));
        
        V5 = [t*(V1314+V2324)/(norm(V1314+V2324)*cos(alpha1/2)*cos(beta/2)) 0 0 0 0];
        P2 = [Pi 0 0 i j] + V5;
        if ~isnan(P2)
            if K1i<K2i
                P2(4) = 1;
            end
            if K1j<K2j
                P2(5) = 1;
            end
            O(in,:) = P2;
            in=1+in;
        end
    end
end

%% Trim intersecting points
% i = 2;
% trim = zeros(size(O,1),1);
% while i<size(O,1)-1
%     if O(i,4)==1
%         if O(i,7)==O(i-1,7) && O(i-1,2)>O(i,2)
%             trim(i-1)=1;
%         end
%         if O(i,7)==O(i+1,7) && O(i+1,2)<O(i,2)
%             trim(i+1)=1;
%         end
%     end
%     i=i+1;
% end
% 
% O = sortrows(O,7);
% 
% i = 2;
% while i<size(O,1)-1
%     if O(i,5)==1
%         if O(i,6)==O(i-1,6) && O(i-1,1)>O(i,1)
%             trim(i-1)=1;
%         end
%         if O(i,7)==O(i+1,6) && O(i+1,1)<O(i,1)
%             trim(i+1)=1;
%         end
%     end
%     i=i+1;
% end
% 
% indices = trim==1;
% O(indices,:)=[];

%% remove 0s
O = O(any(O,2),:);
O = O(:,1:3);

%%
IN = inpolyhedron(T,P,O);
indices = IN==0;
O(indices,:)=[];

%% Output only Z values at original X, Y points
Z2 = griddata(O(:,1),O(:,2),O(:,3),X,Y);

end
