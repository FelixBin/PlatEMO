function Trial = borderUpdate(Trial, Low,Up,N,D)
% Boundary Control Mechansim
for i = 1 : N
    for j = 1 : D
        if Trial(i,j) < Low(j)
            Trial(i,j)  =  rand * ( Up(j)-Low(j) ) + Low(j) ;
        end
        if Trial(i,j) >  Up(j)
            Trial(i,j)  =  rand * ( Up(j)-Low(j) ) + Low(j) ;
        end
    end
end
end

