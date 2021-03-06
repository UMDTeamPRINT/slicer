function Po = mean_raise(t,T,P,N)

Po=zeros(size(P));

% For each point, raise by average normal
for i=1:size(P,1)
    
    % Point we're looking at
    p=P(i,:);
    
    ns = zeros(6,3);
    
    % Find attached triangles
    cn=1;
    for j=1:size(T,1)
        % ismember is slow when dealing with small arrays.
        % instead check directly if triangle is adjacent through brute
        % force means.
        for k=1:3
            if T(j,k)==i
                ns(cn,:)=N(j,:)/norm(N(j,:));
                cn=cn+1;
            end
        end
    end
    
    % Trim normals of any 0s
    ns = ns(any(ns,2),:);
    
    avgn = zeros(1,3);
    
    % Sum normals
    for j=1:size(ns,1)
        avgn=avgn+ns(j,:);
    end
    
    % Normalize normals
    avgn = t*avgn/norm(avgn);
    
    Po(i,:) = p+avgn;
end
end