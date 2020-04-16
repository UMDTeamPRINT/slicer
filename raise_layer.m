% thickness

function [To,Po] = raise_layer(t,T,P)

tolerance = 1E-3;

Po=[];

patch('Faces', T, 'Vertices', P, 'FaceVertexCData', (1:length(T(:,1)))', 'FaceColor', 'flat');
hold on
for i=1:size(T,1)
    tic
    adj=[];
    tt = T(i,:);
    common_points = []; % set of common points (in order of triangles)
    
    % Find adjacent triangles
    for j=1:size(T,1)
        if j~=i
            % ismember is slow when dealing with small arrays.
            % instead check directly if triangle is adjacent through brute
            % force means.
            sum = 0;
            for k=1:3
                for u=1:3
                    if tt(k)==T(j,u)
                        sum=sum+1;
                        cp(sum) = tt(k);
                    end
                end
            end
            if sum==2
                adj = [adj;T(j,:)];
                common_points(:,:,size(common_points,3)+1) = [P(cp(1),:);P(cp(2),:)];
            end
        end
    end
    
    % Save triangles raw points values
    % Don't try to understand it, it's stupid
    ts(:,:,1) = P(sub2ind(size(P),[tt(1,:);tt(1,:);tt(1,:)]',[1:3;1:3;1:3]));
    ts(:,:,2) = P(sub2ind(size(P),[adj(1,:);adj(1,:);adj(1,:)]',[1:3;1:3;1:3]));
    ts(:,:,3) = P(sub2ind(size(P),[adj(2,:);adj(2,:);adj(2,:)]',[1:3;1:3;1:3]));
    ts(:,:,4) = P(sub2ind(size(P),[adj(3,:);adj(3,:);adj(3,:)]',[1:3;1:3;1:3]));
    
    
    % Project  points
    ns = zeros(4,3);
    rts = zeros(3,3,4);
    for j=1:4
        % Find normal of triangle and scale to thickness
        tt = ts(:,:,j);
        n = cross((tt(2,:)-tt(1,:)),(tt(3,:)-tt(1,:)));
        n = n/norm(n);
        ns(j,:) = t*n;
        
        % Save raised triangles
        rts(:,:,j) = ts(:,:,j)+[ns(j,:);ns(j,:);ns(j,:)];
    end
    
    % Find line of each plane intersect with original triangle
    point = zeros(4,3);
    dir = zeros(4,3);
    for j=2:4
        % compute the angle between the normals
        angle = acos(dot(ns(1,:),ns(j,:)) / t^2);
        
        if angle > tolerance
            [point(j,:), dir(j,:)] = plane_intersect(ns(1,:),rts(1,:,j),ns(j,:),rts(1,:,j));
        else
            point(j,:) = common_points(1,:,j) + ns(j,:);
            dir(j,:) = common_points(1,:,j) - common_points(2,:,j);
        end
    end
    
    % Uses x^2 to get intersection. Need to find explicit form.
%     np(1,:) = lineXline([point(2,:);point(3,:)],[point(2,:)+dir(2,:);point(3,:)+dir(3,:)]);
%     np(2,:) = lineXline([point(3,:);point(4,:)],[point(3,:)+dir(3,:);point(4,:)+dir(4,:)]);
%     np(3,:) = lineXline([point(4,:);point(2,:)],[point(4,:)+dir(4,:);point(2,:)+dir(2,:)]);
    
    % Uses exact form. fails for any singularity (any flat surface)
    % TODO figure out how to fix for singularities
%     np(1,:) = point(2,:)+dir(2,:)*((dir(3,2)*point(2,3) - dir(3,3)*point(2,2) - dir(3,2)*point(3,3) + dir(3,3)*point(3,2))/(dir(2,2)*dir(3,3) - dir(3,2)*dir(2,3)));
%     np(2,:) = point(3,:)+dir(3,:)*((dir(4,2)*point(3,3) - dir(4,3)*point(3,2) - dir(4,2)*point(4,3) + dir(4,3)*point(4,2))/(dir(3,2)*dir(4,3) - dir(4,2)*dir(3,3)));
%     np(3,:) = point(4,:)+dir(4,:)*((dir(2,2)*point(4,3) - dir(2,3)*point(4,2) - dir(2,2)*point(2,3) + dir(2,3)*point(2,2))/(dir(4,2)*dir(2,3) - dir(2,2)*dir(4,3)));
%         
    % Explicit Solution that's better from here: https://math.stackexchange.com/q/2213256
    for j=2:4
        a=point(j,:);
        b=dir(j,:);
        if j+1>4
            c=point(2,:);
            d=dir(2,:);
        else
            c=point(j+1,:);
            d=dir(j+1,:);
        end
        e=a-c;
        A=-(dot(b,b)*dot(d,d)-dot(b,d)^2);
        sss=(-dot(b,b)*dot(d,e)+dot(b,e)*dot(d,b))/A;
        ttt=(dot(d,d)*dot(b,e)-dot(d,e)*dot(d,b))/A;
        
        np1 = a+b*ttt;
        np2 = c+d*sss;
        np(j-1,:)=(np1+np2)/2;
    end
    
%     plot3([np(1,1);ts(2,1,1)],[np(1,2);ts(2,2,1)],[np(1,3);ts(2,3,1)])
%     plot3([np(2,1);ts(3,1,1)],[np(2,2);ts(3,2,1)],[np(2,3);ts(3,3,1)])
%     plot3([np(3,1);ts(1,1,1)],[np(3,2);ts(1,2,1)],[np(3,3);ts(1,3,1)])
    hold on
    Po = [Po;np];
    %toc
end
%xlim([-100 100]);ylim([-100 100]);zlim([-100 100]);
To=[];
%Po=[];
end