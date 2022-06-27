%%最后统计JADE算法run不同测试函数时的均值和方差
%%文化算法与差分进化算法混合
%% 参考资料https://zhuanlan.zhihu.com/p/384422018
clc;
clear;
close all;
format long;
format compact;
runtimes=30;%用于测试多组数据

tic()
% max=input('Input the upper bound:');% 搜索上界
% min=input('Input the lower bound:');% 搜索下界
% gMax=input('Input the Gen:');%最大代数
% nPop=input('Input the nPop:');%种群个数
% indexFun=input('Input the type of TestFuntion:');%测试函数类型

%%测试数据
max=10;
min=-10;
gMax=10;
nPop=50;
indexFun=1;
%% 测试多次迭代后最好的集合的平均值、标准差准备
for i=1:runtimes
    bestCost=CA(max,min,gMax,nPop,indexFun);
    bestValue(i)=bestCost(end);
end


%% Results
mean_bestValue=mean(bestValue);%平均值
std_bestValue=std(bestValue);%标准差
disp(strcat('第',num2str(indexFun),'个函数平均值、标准差结果分别为：mean=',num2str(mean_bestValue),' , std=',num2str(std_bestValue)));
toc()

%% 绘制最后一组
figure;
semilogy(bestCost, 'LineWidth', 2);
xlabel('Iteration');
ylabel('Best Cost');
grid on;


