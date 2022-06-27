% (c) besdok TSP 2-OPT
%{

x=rand(100,2);
[err,sol]=my_tsp0(x)

unoptimized 2-opt code for the lecture notes for 'Modern Data Processing Tech.'.

%}
function [sol,fit]=my_tsp_2opt(x,sol)

N=size(x,1);
% sol=randperm(N);
fnc = @(x,ind) sum( sqrt( sum( (x(ind(1:N-1),:)-x(ind(2:N),:)).^2,2 ) )  );
fit = fnc(x,sol);

while 1
say=0;   
for i=1:N   
    for j=1:N
        v=sol;
        cc=v(i:j);
        cc=fliplr(cc);
        v(i:j)=cc;
        sv = fnc( x, v );
        if sv < fit
            fit = sv;
            sol = v;
            say=1;
        end

    end
    
end

 if say==0, break; end   
  sol=fliplr(sol);      
end















