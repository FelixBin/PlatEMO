%%%%%%%%%%%%%%%%%��ֽ����㷨������ֵ%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%
function [y ,yf,trace]=DE(objfun,D,G,NP,ub,lb)

G;                                %����������
NP;                                %������Ŀ
D;                                 %���Ż�������ά��
%
x=(ub-lb)*rand(NP,D)+lb;
F0=0.5;                               %��ʼ��������
CR=0.3;                               %��������
Xs=ub;                                %����
Xx=lb;                               %����
yz=10^-6;                             %��ֵ


%%%%%%%%%%%%%%%%%%%%%%%%%����ֵ%%%%%%%%%%%%%%%%%%%%%%%%
x=x';                        %��ʼ��Ⱥ
v=x*rand;                        %������Ⱥ
u=x*rand;                        %ѡ����Ⱥ
%%%%%%%%%%%%%%%%%%%%����Ŀ�꺯��%%%%%%%%%%%%%%%%%%%%
Ob=[];
Ob1=[];

for m=1:NP
    Ob(m)=objfun(x(:,m)');
end
[fbest,index]=min(Ob);
best=x(:,index);
trace(1)=fbest;
%%%%%%%%%%%%%%%%%%%%%%%��ֽ���ѭ��%%%%%%%%%%%%%%%%%%%%%
for gen=1:G
    %%%%%%%%%%%%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%����Ӧ��������%%%%%%%%%%%%%%%%%%%
    lamda=exp(1-G/(G+1-gen));
    F=F0*2^(lamda);
    %%%%%%%%%%%%%%%%%r1,r2��m������ͬ%%%%%%%%%%%%%%%%
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
    
    %%%%%%%%%%%%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%%%%%%%
    r=randi([1,NP],1,1);
    for n=1:D
        cr=rand(1);
        if (cr<=CR)|(n==r)
            u(n,:)=v(n,:);
        else
            u(n,:)=x(n,:);
        end
    end
    %%%%%%%%%%%%%%%%%%%�߽������Ĵ���%%%%%%%%%%%%%%%%%%%%%
    for n=1:D
        for m=1:NP
            if (u(n,m)<Xx)|(u(n,m)>Xs)
                u(n,m)=rand*(Xs-Xx)+Xx;
            end
        end
    end
    %%%%%%%%%%%%%%%%%%%%%%ѡ�����%%%%%%%%%%%%%%%%%%%%%%%
    for m=1:NP
        Ob1(m)=objfun(u(:,m));%�¸���
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
