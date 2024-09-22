% this function find extrema point
% z is extrema point array
% t is determine type of extrema point

function [z , t] = extrema(dy,y)
k=0;
t=zeros(1,k);
N_gs = length(dy);
z=zeros(1,k);

for j = 1 : N_gs-1
    
    if (dy(j)<0) && (dy(j+1)>0)
        k=k+1;
        if abs(dy(j))<abs(dy(j+1))
            z(1,k)=j;
        else
            z(1,k) = j+1;
        end
        t(1,k)=-1;  % minimum
    end
    
    if (dy(j)>0) && (dy(j+1)<0)
        k=k+1;
        if abs(dy(j))<abs(dy(j+1))
            z(1,k)=j;
        else
            z(1,k) = j+1;
        end
        t(1,k)=+1;  % maximum
    end
    
end
% not exist extrema
if isempty(z)
    if y(N_gs-1)>y(1)
    z(1,1)=min(y);
    t(1,1)=-1;
    z(1,2)=max(y);
    t(1,2)=1;
    else
    z(1,1)=max(y);
    t(1,1)=1;
    z(1,2)=min(y);
    t(1,2)=-1;
    end
end

end
