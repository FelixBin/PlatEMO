function [BestCost] = ca(max,min,gMax,nPop,indexFun)
%CA 此处显示有关此函数的摘要
%max:搜索上界
%min：搜索下界
%gMax:最大迭代次数
%   此处显示详细说明

type=indexFun;


%% Problem Definition  优化问题参数

%寻优函数
CostFunction = @(type,x) TestFunction(type,x);        % Cost Function


nVar = 10;          % Number of Decision Variables 决策变量个数（维度）

VarSize = [1 nVar];   % Decision Variables Matrix Size 决策变量矩阵（维度）

VarMin = min%-10;         % Decision Variables Lower Bound  决策变量下界
VarMax =max %10;         % Decision Variables Upper Bound  决策变量上界

%% Cultural Algorithm Settings  文化算法参数设置

MaxIt = gMax;%1000;         % Maximum Number of Iterations  迭代次数

nPop = nPop;            % Population Size 种群个数

pAccept = 0.35;                   % Acceptance Ratio 接受比例
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals  接受个体数
alpha = 0.3;


%% Initialization 初始化

% Initialize Culture  （1）信念空间初始化
Culture.Situational.Cost = inf;
Culture.Normative.Min = inf(VarSize);
Culture.Normative.Max = -inf(VarSize);
Culture.Normative.L = inf(VarSize);
Culture.Normative.U = inf(VarSize);


% Empty Individual Structure  清空个体结构
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Generate Initial Solutions （2）初始化种群空间
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize); %从VarMin到VarMax分VarMax段  理解成横坐标x的范围
    pop(i).Cost = CostFunction(type,pop(i).Position);%计算目标函数
end

% Sort Population  （3）根据适应度值排序
%%%[sA,index] = sort(A) 排序后，sA是排序好的向量，index 是 向量sA 中对 A 的索引  对pop.Cost升序

[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder); %根据Cost升序排序后的种群值

% Adjust Culture using Selected Population  用从种群空间选择的精英调整信念空间
spop = pop(1:nAccept);%选择的精英个体

Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found  信念空间最好的函数值
BestSol = Culture.Situational;

% Array to Hold Best Costs
BestCost = zeros(MaxIt, 1);

%% Cultural Algorithm Main Loop

for it = 1:MaxIt  %迭代次数
    
    % Influnce of Culture  指导函数
    for i = 1:nPop  %种群个数
        
        % % 3rd Method (using Normative and Situational components)
        % %同时使用上下界及对应适应度值和cost
        for j = 1:nVar
            sigma = alpha*Culture.Normative.Size(j);
            dx = sigma*randn;
            if pop(i).Position(j)<Culture.Situational.Position(j)
                dx = abs(dx);
            elseif pop(i).Position(j)>Culture.Situational.Position(j)
                dx = -abs(dx);
            end
            pop(i).Position(j) = pop(i).Position(j)+dx;%使用dx来指导走的方向
        end
        
        pop(i).Cost = CostFunction(type,pop(i).Position);
    end
    
    
    % Sort Population
    [~, SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);
    
    % Adjust Culture using Selected Population
    spop = pop(1:nAccept);
    Culture = AdjustCulture(Culture, spop);
    
    % Update Best Solution Ever Found
    BestSol = Culture.Situational;
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
    
end

end

