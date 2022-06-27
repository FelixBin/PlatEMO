%%%%%%%%%%%%%%%%%差分进化算法求函数极值%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%初始化%%%%%%%%%%%%%%%%%%%%%%%%%
function [y ,yf,trace]=DE(objfun,D,G,NP,ub,lb)

G;                                %最大进化代数
NP;                                %个体数目
D;                                 %待优化变量的维数
%
x=(ub-lb)*rand(NP,D)+lb;
F0=0.5;                               %初始变异算子
CR=0.3;                               %交叉算子
Xs=ub;                                %上限
Xx=lb;                               %下限
yz=10^-6;                             %阈值


%%%%%%%%%%%%%%%%%%%%%%%%%赋初值%%%%%%%%%%%%%%%%%%%%%%%%
x=x';                        %初始种群
v=x*rand;                        %变异种群
u=x*rand;                        %选择种群
%%%%%%%%%%%%%%%%%%%%计算目标函数%%%%%%%%%%%%%%%%%%%%
Ob=[];
Ob1=[];

for m=1:NP
    Ob(m)=objfun(x(:,m)');
end
[fbest,index]=min(Ob);
best=x(:,index);
trace(1)=fbest;
%%%%%%%%%%%%%%%%%%%%%%%差分进化循环%%%%%%%%%%%%%%%%%%%%%
for gen=1:G
    %%%%%%%%%%%%%%%%%%%%%%变异操作%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%自适应变异算子%%%%%%%%%%%%%%%%%%%
    lamda=exp(1-G/(G+1-gen));
    F=F0*2^(lamda);
    %%%%%%%%%%%%%%%%%r1,r2和m互不相同%%%%%%%%%%%%%%%%
    for m=1:NP
        r1=randi([1,NP],1,1);
        while (r1==m)
            r1=randi([1,NP],1,1);
        end
        r2=randi([1,NP],1,1);
        while (r2==m)|(r2==r1)
            r2=randi([1,NP],1,1);
        end
        
        v(:,m)=x(:,m)+F*(x(:,r1)-x(:,r2));
    end
    
    %%%%%%%%%%%%%%%%%%%%%%交叉操作%%%%%%%%%%%%%%%%%%%%%%%
    r=randi([1,NP],1,1);
    for n=1:D
        cr=rand(1);
        if (cr<=CR)|(n==r)
            u(n,:)=v(n,:);
        else
            u(n,:)=x(n,:);
        end
    end
    %%%%%%%%%%%%%%%%%%%边界条件的处理%%%%%%%%%%%%%%%%%%%%%
    for n=1:D
        for m=1:NP
            if (u(n,m)<Xx)|(u(n,m)>Xs)
                u(n,m)=rand*(Xs-Xx)+Xx;
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%选择操作%%%%%%%%%%%%%%%%%%%%%%%
    for m=1:NP
        Ob1(m)=objfun(u(:,m));%新个体
    end
    
    for m=1:NP
        if Ob1(m)<Ob(m)
            x(:,m)=u(:,m);
        end
    end
    
    for m=1:NP
        Ob(m)=objfun(x(:,m));
    end
    
    [fbest_now ,best_now]=min(Ob);
    if fbest_now<fbest
        fbest=fbest_now;
        best=x(:,best_now);
    end
    
    trace(gen,1)=fbest;
    if min(Ob(m))<yz
        break
    end
end
y=best;
yf=fbest;

end
