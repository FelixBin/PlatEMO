%%���ͳ��JADE�㷨run��ͬ���Ժ���ʱ�ľ�ֵ�ͷ���
clear all;
format long;
format compact;

runtime=50;
% type=13;
%%����������һ�����ʹ�ã�tic��ʾ��ʱ�Ŀ�ʼ��toc��ʾ��ʱ�Ľ�����
tic()
% for i=1:type
max=input('Input the upper bound:');% max=100;%�����Ͻ�

min=input('Input the lower bound:');% min=-100;%�����½�
gMax=input('Input the Gen:');%����
indexFun=input('Input the type of TestFuntion:');%���Ժ�������

for j=1:runtime
    bestValue(j)=JADE_demo(max,min,gMax,indexFun);
end
mean_bestValue=mean(bestValue);%ƽ��ֵ
std_bestValue=std(bestValue);%��׼��
disp(strcat('��',num2str(indexFun),'������ƽ��ֵ����׼�����ֱ�Ϊ��mean=',num2str(mean_bestValue),' , std=',num2str(std_bestValue)));
% end

toc()
