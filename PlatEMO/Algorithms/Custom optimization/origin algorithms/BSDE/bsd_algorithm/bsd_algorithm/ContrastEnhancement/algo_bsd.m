
%{

Civicioglu, P., Besdok, E., (2018), Bernstain-Search Differential Evolution
Algorithm for Numerical Function Optimization, Image Vectorization and
Triangulated Irregular Network Refinement, (under review)


(c) BESDOK

%}


function out = algo_bsd(fnc,mydata,N,D,Low,Up,epk)

if numel(Low) < D, Low=repmat( Low,[1 D] ); end
if numel(Up)  < D,  Up=repmat(  Up,[1 D] ); end

p = rand(N,D); % memory
% see Line 1 of Figure#1 of the manuscript
for i = 1 : N
    for j = 1 : D
        p(i,j) = rand .* ( Up(j) - Low(j) ) + Low(j);
    end
end

if isfield(mydata,'initsol'), p(1,:)=mydata.initsol; end

% see Line 2 of Figure#1 of the manuscript
fitP = feval( fnc , p , mydata );

% see Line 3 of Figure#1 of the manuscript
[~,j] = min( fitP );
bestP = p(j,:);

for epk = 1 : epk
    
    % see Lines 5 of Figure#1 of the manuscript
    M = zeros(N,D) ;
    % see Lines 6-16 of Figure#1 of the manuscript
    for i = 1 : N
        alpha = GetAlpha; 
%         u = randperm( D, ceil( alpha * D ) ); 
%         M(i,u) = 1;  
      u = randperm( D );
        M(i,u(1:ceil( alpha * D ))) = 1;
    end
    
    % see Lines 17-22 of Figure#1 of the manuscript
    if rand^3 < rand
        F = rand( 1, D ).^3 .* abs( randn( 1, D ) ) .^ 3 ;
    else
        F = randn( N, 1 ) .^ 3 ;
    end
    
    % see Lines 23 of Figure#1 of the manuscript
    while 1, L1 = randperm(N); L2 = randperm(N); if sum( L1 == 1:N, 2)==0 && sum( L1 == L2, 2)==0 && sum( L2 == 1:N , 2 )==0, break; end, end
    
    % see Line 24 of Figure#1 of the manuscript
    w1 = rand( N, D ) ;
    E = ( w1 .* p(L1,:) + (1-w1) .* p(L2,:) ) ;
    
    % see Line 25 of Figure#1 of the manuscript
    w2 = 1 - rand( N, 1 ).^3 ;
    Trial = p +  F .*  M .* ( w2 .* E + ( 1 - w2 ) .* bestP   - p  ) ;
    
    % see Line 26 of Figure#1 of the manuscript
    Trial = borderUpdate( Trial, Low, Up, N, D );
    
    % see Lines 27-29 of Figure#1 of the manuscript
    fitTrial = feval( fnc, Trial, mydata );
    j = fitTrial < fitP;
    fitP(j) = fitTrial(j);
    p(j,:) = Trial(j,:);
    [solP,j] = min(fitP);
    bestP = p(j,:);
    out.globalminimum = solP;
    out.globalminimizer = bestP;
    assignin('base','outAlgo',out);
    fprintf('BSD | %3.0f %3.0f|%3.0f -> %5.16f\n',N,D,epk,solP);
    
    
end


% see Lines 26 of Figure#1 of the manuscript
function Trial = borderUpdate(Trial, Low, Up, N, D)
for i = 1 : N
    for j = 1 : D
        if Trial(i,j) < Low(j), Trial(i,j)  =  rand * ( Up(j)-Low(j) ) + Low(j) ; end
        if Trial(i,j) >  Up(j), Trial(i,j)  =  rand * ( Up(j)-Low(j) ) + Low(j) ; end
    end
end


% see Lines 9-14 of Figure#1 of the manuscript
function p = GetAlpha
beta = rand;
kappa = ceil( 3 * (rand.^3) );
switch kappa
    case 1, p = beta .^ 2;
    case 2, p = 2*(1-beta) * beta;
    case 3, p = (1-beta) .^ 2;
end





