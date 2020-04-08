function [To,Po] = raise_layer(t,T,P)
Po=[];
syms x y z;
for i=1:size(T,1)
    tic
    adj=[];
    tt = T(i,:);
    for j=1:size(T,1)
        if j~=i
            % ismember is slow when dealing with small arrays.
            sum = 0;
            for k=1:3
                for u=1:3
                    if tt(k)==T(j,u)
                        sum=sum+1;
                    end
                end
            end
            if sum==2
                adj = [adj;T(j,:)];
            end
        end
    end
    
    % Save 4 triangles' points
    ts(:,:,1) = P(sub2ind(size(P),[tt(1,:);tt(1,:);tt(1,:)]',[1:3;1:3;1:3]));
    ts(:,:,2) = P(sub2ind(size(P),[adj(1,:);adj(1,:);adj(1,:)]',[1:3;1:3;1:3]));
    ts(:,:,3) = P(sub2ind(size(P),[adj(2,:);adj(2,:);adj(2,:)]',[1:3;1:3;1:3]));
    ts(:,:,4) = P(sub2ind(size(P),[adj(3,:);adj(3,:);adj(3,:)]',[1:3;1:3;1:3]));
    
    
    ns = zeros(4,3);
    rts = zeros(3,3,4);
    for j=1:4
        tt = ts(:,:,j);
        n = cross((tt(2,:)-tt(1,:)),(tt(3,:)-tt(1,:)));
        n = n/norm(n);
        ns(j,:) = t*n;

        rts(:,:,j) = ts(:,:,j)+[ns(j,:);ns(j,:);ns(j,:)];

        %ps(:,j) = 0==dot(ns(j,:),[x y z]-rts(1,:,j));
    end
    
    point = zeros(4,3);
    dir = zeros(4,3);
    for j=2:4
        [point(j,:), dir(j,:)] = plane_intersect(ns(1,:),rts(1,:,j),ns(j,:),rts(1,:,j));
    end
    
    np(1,:) = lineXline([point(2,:);point(3,:)],[point(2,:)+dir(2,:);point(3,:)+dir(3,:)]);
    np(2,:) = lineXline([point(3,:);point(4,:)],[point(3,:)+dir(3,:);point(4,:)+dir(4,:)]);
    np(3,:) = lineXline([point(4,:);point(2,:)],[point(4,:)+dir(4,:);point(2,:)+dir(2,:)]);
    
    Po = [Po;np];
    %toc
end

To=[];
%Po=[];
end