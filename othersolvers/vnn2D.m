function [estimated, processing_time] = vnn2D(observed, mask, tx, ty)

t0 = cputime;

[M,N] = size(observed);


tx = reshape(tx,M,N);
ty = reshape(ty,M,N);
% tz = reshape(tz,M,N,noPlanes);


maskvec = mask(:);

y = observed(:);


%%%% voxel nearest neighbour

estimated = reshape(y,M,N);

ll = [1; 1];
ul = [M; N];

for i = 1:M
    for j = 1:N
%         for k = 1:L
            
            if ~mask(i,j)
                Pin = [i;j];
                
                dist = [];
                proj_pts = [];

%                 for slice = 1:noPlanes

                    if maskvec(N*(Pin(2)-1)+Pin(1))==0

                    c = [tx(1,1);ty(1,1)];
                    b = [tx(1,N);ty(1,N)];
                    a = [tx(M,1);ty(M,1)];

%                     ll = [tx(1,1,slice);ty(1,1,slice);tz(1,1,slice)];
%                     ul = [tx(n,n,slice);ty(n,n,slice);tz(n,n,slice)];

                    [po, d] = projectPointonPlane(Pin,a,b,c,ll,ul);
                    dist = [dist, d];
                    proj_pts = [proj_pts, po];

                    end

%                 end

                ind = find(abs(dist)==min(abs(dist)),1,'first');

                vox_value = y( round( N*(proj_pts(2,ind)-1)+proj_pts(1,ind) ) );
                estimated(i,j) = vox_value;
    
            end
            
%         end
    end
end
    
processing_time = cputime-t0;
