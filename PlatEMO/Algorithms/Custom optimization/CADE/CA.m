function [BestCost] = CA(max,min,gMax,nPop,indexFun)
%CA �˴���ʾ�йش˺�����ժҪ
%max:�����Ͻ�
%min�������½�
%gMax:����������
%   �˴���ʾ��ϸ˵��

type=indexFun;


%% Problem Definition  �Ż��������

%Ѱ�ź���
CostFunction = @(type,x) TestFunction(type,x);        % Cost Function

nVar = 10;          % Number of Decision Variables ���߱�������

VarSize = [1 nVar];   % Decision Variables Matrix Size ���߱�������ά�ȣ�

VarMin = min;%-10;         % Decision Variables Lower Bound  ���߱����½�
VarMax =max; %10;         % Decision Variables Upper Bound  ���߱����Ͻ�

%% Cultural Algorithm Settings  �Ļ��㷨��������

MaxIt = gMax;%1000;         % Maximum Number of Iterations  ��������

nPop = nPop;            % Population Size ��Ⱥ����

pAccept = 0.35;                   % Acceptance Ratio ���ܱ���
nAccept = round(pAccept*nPop);    % Number of Accepted Individuals  ���ܸ�����
alpha = 0.3;

%%��Ⱥ��������
F0=0.4;                               %��ʼ��������
CR=0.1;                               %��������

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
pop = repmat(empty_individual, nPop, 1);%��ʼ��Ⱥ����
mutation= repmat(empty_individual, nPop, 1);%���춨��
cross=repmat(empty_individual, nPop, 1);%���涨��

% Generate Initial Solutions ��2����ʼ����Ⱥ�ռ�
for i = 1:nPop
    
    %%��ʼ��Ⱥ
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize); %��VarMin��VarMax��VarMax��  ���ɺ�����x�ķ�Χ
    pop(i).Cost = CostFunction(type,pop(i).Position);%ÿ������  ����Ŀ�꺯��
    
    %%�����ʼ��
    mutation(i).Position=pop(i).Position;
    %mutation(i).Cost=pop(i).Cost;
    
    %%�����ʼ��
    cross(i).Position=pop(i).Position;
    %cross(i).Cost=pop(i).Cost;
end

% Sort Population  ��3��������Ӧ��ֵ����

[~, SortOrder] = sort([pop.Cost]);
pop = pop(SortOrder); %����Cost������������Ⱥֵ

% Adjust Culture using Selected Population  �ô���Ⱥ�ռ�ѡ��ľ�Ӣ��������ռ�
spop = pop(1:nAccept);%ѡ��ľ�Ӣ����

Culture = AdjustCulture(Culture, spop);

% Update Best Solution Ever Found  ����ռ���õĺ���ֵcost
BestSol = Culture.Situational;

% Array to Hold Best Costs  ÿһ����õ�ֵ
BestCost = zeros(MaxIt, 1);

%% Cultural Algorithm Main Loop

for it = 1:MaxIt  %��������
    % Influnce of Culture  ָ������
    %%%%%%%%%%%%%%%%%%%����Ӧ��������%%%%%%%%%%%%%%%%%%%
    lamda=exp(1-MaxIt/(MaxIt+1-it));
    F=F0*2^(lamda);
    
    %%%%%%%%%%%%%%%%%���� r1,r2��m������ͬ%%%%%%%%%%%%%%%%
    for i = 1:nPop  %��Ⱥ����
        r1=randi(VarSize,1,1);
        while (r1==i)
            r1=randi(VarSize,1,1);
        end
        r2=randi(VarSize,1,1);
        while (r2==i)|(r2==r1)
            r2=randi(VarSize,1,1);
        end
        %  ������ͬ��r1,r2,r3
        mutation(i).Position= pop(i).Position+F*(pop(r1).Position-pop(r2).Position);%����
    end
    %%%%%%%%%%%%%%%%%����  r1,r2��m������ͬ%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%%%%
    r=randi(VarSize,1,1);
    for n=1:nVar  %nVar��������
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
    %%%%%%%%%%%%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%�߽������Ĵ���%%%%%%%%%%%%%%%%%%%%%
    for m=1:nPop
        for n=1:nVar
            if (cross(m).Position(n)<VarMin)|(cross(m).Position(n)>VarMax)
                cross(m).Position(n)=rand*(VarMax-VarMin)+VarMin; %������������µĸ���
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%ѡ�����%%%%%%%%%%%%%%%%%%%%%%%
    
    %% (1)�����µ���Ӧ��
    for j=1:nPop
        cross(i).Cost = CostFunction(type,cross(i).Position);%�µĸ����costֵ
    end
    %%(2)�Ƚ�ɸѡ
    %����crossΪ����ѡ������Ⱥ x
    for m=1:nPop
        if cross(m).Cost<pop(m).Cost
            %initPop(m,:)=mutation(m,:);
            pop(m).Position=cross(m).Position;
        end
    end
    
    %%(3)�ٴμ���ɸѡ�����Ӧ��
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

