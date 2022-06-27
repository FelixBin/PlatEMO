
function [out,xy0,xy1]=my_simplified_geometry(X,mydata)
xy = mydata.xy;
K=mydata.K;
n = size(X,1);
out = size(n,1);
fnc=mydata.fnc;
for i=1:n
    
    xy0 = X(i,:);
    
    
    xy0 = ppval(fnc,xy0)';
     
    [sol,fit]= my_tsp_2opt(xy0,randperm(K));    
    xy0=xy0(sol,:);
    
    v=[xy0;xy0(1,:)];
    fnc2=cscvn(v');
    xy1=ppval(fnc2,linspace(0,max(fnc2.breaks),K*20))';
    
    out(i) = -fit +  DiscreteFrechetDist(xy1,xy);
    
    
end


