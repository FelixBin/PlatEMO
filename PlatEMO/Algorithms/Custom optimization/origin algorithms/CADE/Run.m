%%���ͳ��JADE�㷨run��ͬ���Ժ���ʱ�ľ�ֵ�ͷ���
%%�Ļ��㷨���ֽ����㷨���
%% �ο�����https://zhuanlan.zhihu.com/p/384422018
clc;
clear;
close all;
format long;
format compact;
runtimes=30;%���ڲ��Զ�������

tic()
% max=input('Input the upper bound:');% �����Ͻ�
% min=input('Input the lower bound:');% �����½�
% gMax=input('Input the Gen:');%������
% nPop=input('Input the nPop:');%��Ⱥ����
% indexFun=input('Input the type of TestFuntion:');%���Ժ�������

%%��������
max=10;
min=-10;
gMax=10;
nPop=50;
indexFun=1;
%% ���Զ�ε�������õļ��ϵ�ƽ��ֵ����׼��׼��
for i=1:runtimes
    bestCost=CA(max,min,gMax,nPop,indexFun);
    bestValue(i)=bestCost(end);
end


%% Results
mean_bestValue=mean(bestValue);%ƽ��ֵ
std_bestValue=std(bestValue);%��׼��
disp(strcat('��',num2str(indexFun),'������ƽ��ֵ����׼�����ֱ�Ϊ��mean=',num2str(mean_bestValue),' , std=',num2str(std_bestValue)));
toc()

%% �������һ��
figure;
semilogy(bestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;


