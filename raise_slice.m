function Z2 = raise_slice(t,X,Y,Z)
% See [1]Bin Huang, “Development of a Software procedure for Curved layered Fused DepositionModelling (CLFDM),” Master Thesis, Auckland University of Technology, 2009.
% Implementation of MFVCP
nx = size(X,2);
ny = size(Y,1);
O = zeros(nx*ny,6);
in = 1;
V3 = [1 0 0];
for j=1:ny
    for i=2:nx-1
        Pi_minus_1 = [X(i-1,j) Y(i-1,j) Z(i-1,j)];
        Pi_plus_1 = [X(i+1,j) Y(i+1,j) Z(i+1,j)];
        Pi = [X(i,j) Y(i,j) Z(i,j)];
        K1 = (Pi(3)-Pi_minus_1(3))/(Pi(2)-Pi_minus_1(2));
        K2 = (Pi_plus_1(3)-Pi(3))/(Pi_plus_1(2)-Pi(2));
        V1 = Pi_minus_1 - Pi;
        V2 = Pi_plus_1 - Pi;
        V13 = t.*cross(V1,V3)./norm(cross(V1,V3));
        V23 = t.*cross(V3,V2)./norm(cross(V3,V2));
        alpha = acos(dot(V13,V23)./(norm(V13)*norm(V23)));
        V5 = [t.*(V13+V23)./(cos(alpha/2)*norm(V13+V23)) 0 0 0];
        P2 = [X(i,j) Y(i,j) Z(i,j) 0 i j] + V5;
        if ~isnan(P2)
            if K1<K2
                P2(4) = 1;
            end
            O(in,:) = P2;
            in=1+in;
        end
    end
end

i = 2;
while i<size(O,1)-1
    if O(i,4)==1
        if O(i,6)==O(i-1,6) && O(i-1,2)>O(i,2)
            O(i-1,:)=[];
            i = i-1;
        end
        if O(i,6)==O(i+1,6) && O(i+1,2)<O(i,2)
            O(i+1,:)=[];
            i = i-1;
        end
    end
    i=i+1;
end

O = O(any(O,2),:);
Z2 = griddata(O(:,1),O(:,2),O(:,3),X,Y);

end
