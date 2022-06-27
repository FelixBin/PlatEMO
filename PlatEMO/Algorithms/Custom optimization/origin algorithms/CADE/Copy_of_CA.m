function [BestCost] = ca(max,min,gMax,nPop,indexFun)
%CA �˴���ʾ�йش˺�����ժҪ
%max:�����Ͻ�
%min�������½�
%gMax:����������
%   �˴���ʾ��ϸ˵��

type=indexFun;


%% Problem Definition  �Ż��������

%Ѱ�ź���
CostFunction = @(type,x) TestFunction(type,x);        % Cost Function


nVar = 10;          % Number of Decision Variables ���߱���������ά�ȣ�

VarSize = [1 nVar];   % Decision Variables Matrix Size ���߱�������ά�ȣ�

VarMin = min%-10;         % Decision Variables Lower Bound  ���߱����½�
VarMax =max %10;         % Decision Variables Upper Bound  ���߱����Ͻ�

%% Cultural Algorithm Settings  �Ļ��㷨��������

MaxIt = gMax;%1000;         % Maximum Number of Iterations  ��������

nPop = nPop;            % Population Size ��Ⱥ����

pAccept = 0.35;                   % Acceptance Ratio ���ܱ���
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals  ���ܸ�����
alpha = 0.3;


%% Initialization ��ʼ��

% Initialize Culture  ��1������ռ��ʼ��
Culture.Situational.Cost = inf;
Culture.Normative.Min = inf(VarSize);
Culture.Normative.Max = -inf(VarSize);
Culture.Normative.L = inf(VarSize);
Culture.Normative.U = inf(VarSize);


% Empty Individual Structure  ��ո���ṹ
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Generate Initial Solutions ��2����ʼ����Ⱥ�ռ�
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize); %��VarMin��VarMax��VarMax��  ���ɺ�����x�ķ�Χ
    pop(i).Cost = CostFunction(type,pop(i).Position);%����Ŀ�꺯��
end

% Sort Population  ��3��������Ӧ��ֵ����
%%%[sA,index] = sort(A) �����sA������õ�������index �� ����sA �ж� A ������  ��pop.Cost����

[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder); %����Cost������������Ⱥֵ

% Adjust Culture using Selected Population  �ô���Ⱥ�ռ�ѡ��ľ�Ӣ��������ռ�
spop = pop(1:nAccept);%ѡ��ľ�Ӣ����

Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found  ����ռ���õĺ���ֵ
BestSol = Culture.Situational;

% Array to Hold Best Costs
BestCost = zeros(MaxIt, 1);

%% Cultural Algorithm Main Loop

for it = 1:MaxIt  %��������
    
    % Influnce of Culture  ָ������
    for i = 1:nPop  %��Ⱥ����
        
        % % 3rd Method (using Normative and Situational components)
        % %ͬʱʹ�����½缰��Ӧ��Ӧ��ֵ��cost
        for j = 1:nVar
            sigma = alpha*Culture.Normative.Size(j);
            dx = sigma*randn;
            if pop(i).Position(j)<Culture.Situational.Position(j)
                dx = abs(dx);
            elseif pop(i).Position(j)>Culture.Situational.Position(j)
                dx = -abs(dx);
            end
            pop(i).Position(j) = pop(i).Position(j)+dx;%ʹ��dx��ָ���ߵķ���
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

