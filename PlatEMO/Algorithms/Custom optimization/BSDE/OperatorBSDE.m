function Offspring = OperatorBSDE(Population,bestP,Problem)
% OPERATORBSDE 演化算子
% Population 当前种群
% bestP 当前种群最好的决策变量
% Low 下边界
% Up 上边界
% N 个体数
% D 个体维度数

N=Problem.N;
D=Problem.D;
Low=Problem.lower;
Up=Problem.upper;

if numel(Low) < D
    Low=repmat( Low,[1 D] );
end
if numel(Up)  < D
    Up=repmat( Up,[1 D] );
end

%% Generation of Mutation Control Matrix:M
M = zeros(N,D) ;
for i = 1 : N
    alpha = GetAlpha;
    u = randperm( D );
    M(i,u(1:ceil( alpha * D ))) = 1;
end

% Generation of Evolutionary Step Size:F
if rand^3 < rand
    F = rand( 1, D ).^3 .* abs( randn( 1, D ) ) .^ 3 ;
else
    F = randn( N, 1 ) .^ 3 ;
end

% Generation of Bijective-Direction Vectors
while 1
    L1 = randperm(N);
    L2 = randperm(N);
    if sum( L1 == 1:N, 2)==0 && sum( L1 == L2, 2)==0 && sum( L2 == 1:N , 2 )==0 %b=sum(a,dim); a表示矩阵；dim等于1或者2，1表示每一列进行求和，2表示每一行进行求和；表示每列求和还是每行求和；b表示求得的行向量。
        break;
    end
end

% Generation of Trial Matrix
PopulationDecs=Population.decs;
bestPDecs=bestP.decs;
w1 = rand( N, D ) ;
E = ( w1 .* PopulationDecs(L1,:) + (1-w1) .* PopulationDecs(L2,:) ) ;

w2 = 1 - rand( N, 1 ).^3 ;
Trial = PopulationDecs +  F .*  M .* ( w2 .* E + ( 1 - w2 ) .* bestPDecs   - PopulationDecs  ) ;

% Boundary Control Mechansim
Trial = borderUpdate( Trial,Low,Up,N,D);

Offspring = SOLUTION(Trial);

end

