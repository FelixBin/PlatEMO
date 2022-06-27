function [BestCost] = CA(max,min,gMax,nPop,indexFun)
%CA 此处显示有关此函数的摘要
%max:搜索上界
%min：搜索下界
%gMax:最大迭代次数
%   此处显示详细说明

type=indexFun;


%% Problem Definition  优化问题参数

%寻优函数
CostFunction = @(type,x) TestFunction(type,x);        % Cost Function

nVar = 10;          % Number of Decision Variables 决策变量个数

VarSize = [1 nVar];   % Decision Variables Matrix Size 决策变量矩阵（维度）

VarMin = min;%-10;         % Decision Variables Lower Bound  决策变量下界
VarMax =max; %10;         % Decision Variables Upper Bound  决策变量上界

%% Cultural Algorithm Settings  文化算法参数设置

MaxIt = gMax;%1000;         % Maximum Number of Iterations  迭代次数

nPop = nPop;            % Population Size 种群个数

pAccept = 0.35;                   % Acceptance Ratio 接受比例
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals  接受个体数
alpha = 0.3;

%%种群参数设置
F0=0.4;                               %初始变异算子
CR=0.1;                               %交叉算子

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
pop = repmat(empty_individual, nPop, 1);%初始种群定义
mutation= repmat(empty_individual, nPop, 1);%变异定义
cross=repmat(empty_individual, nPop, 1);%交叉定义

% Generate Initial Solutions （2）初始化种群空间
for i = 1:nPop
    
    %%初始种群
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize); %从VarMin到VarMax分VarMax段  理解成横坐标x的范围
    pop(i).Cost = CostFunction(type,pop(i).Position);%每个个体  计算目标函数
    
    %%变异初始化
    mutation(i).Position=pop(i).Position;
    %mutation(i).Cost=pop(i).Cost;
    
    %%交叉初始化
    cross(i).Position=pop(i).Position;
    %cross(i).Cost=pop(i).Cost;
end

% Sort Population  （3）根据适应度值排序

[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder); %根据Cost升序排序后的种群值

% Adjust Culture using Selected Population  用从种群空间选择的精英调整信念空间
spop = pop(1:nAccept);%选择的精英个体

Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found  信念空间最好的函数值cost
BestSol = Culture.Situational;

% Array to Hold Best Costs  每一代最好的值
BestCost = zeros(MaxIt, 1);

%% Cultural Algorithm Main Loop

for it = 1:MaxIt  %迭代次数
    % Influnce of Culture  指导函数
    %%%%%%%%%%%%%%%%%%%自适应变异算子%%%%%%%%%%%%%%%%%%%
    lamda=exp(1-MaxIt/(MaxIt+1-it));
    F=F0*2^(lamda);
    
    %%%%%%%%%%%%%%%%%变异 r1,r2和m互不相同%%%%%%%%%%%%%%%%
    for i = 1:nPop  %种群个数
        r1=randi(VarSize,1,1);
        while (r1==i)
            r1=randi(VarSize,1,1);
        end
        r2=randi(VarSize,1,1);
        while (r2==i)|(r2==r1)
            r2=randi(VarSize,1,1);
        end
        %  产生不同的r1,r2,r3
        mutation(i).Position= pop(i).Position+F*(pop(r1).Position-pop(r2).Position);%变异
    end
    %%%%%%%%%%%%%%%%%变异  r1,r2和m互不相同%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%交叉操作%%%%%%%%%%%%%%%%%%%%%%%
    r=randi(VarSize,1,1);
    for n=1:nVar  %nVar变量个数
        cr=rand(1);
        if (cr<=CR)|(n==r)
            for g=1:nPop
                cross(g).Position(n)=mutation(g).Position(n);
            end
        else
            for g=1:nPop
                cross(g).Position(n)=pop(g).Position(n);
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%交叉操作%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%边界条件的处理%%%%%%%%%%%%%%%%%%%%%
    for m=1:nPop
        for n=1:nVar
            if (cross(m).Position(n)<VarMin)|(cross(m).Position(n)>VarMax)
                cross(m).Position(n)=rand*(VarMax-VarMin)+VarMin; %重新随机生成新的个体
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%选择操作%%%%%%%%%%%%%%%%%%%%%%%
    
    %% (1)计算新的适应度
    for j=1:nPop
        cross(i).Cost = CostFunction(type,cross(i).Position);%新的个体的cost值
    end
    %%(2)比较筛选
    %现在cross为经过选择后的种群 x
    for m=1:nPop
        if cross(m).Cost<pop(m).Cost
            %initPop(m,:)=mutation(m,:);
            pop(m).Position=cross(m).Position;
        end
    end
    
    %%(3)再次计算筛选后的适应度
    for q=1:nPop
        pop(q).Cost = CostFunction(type,pop(q).Position);
    end
    
    % (4)Sort Population
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

