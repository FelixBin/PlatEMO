%%最后统计JADE算法run不同测试函数时的均值和方差
clear all;
format long;
format compact;

runtime=50;
% type=13;
%%这两个函数一般配合使用，tic表示计时的开始，toc表示计时的结束。
tic()
% for i=1:type
max=input('Input the upper bound:');% max=100;%搜索上界

min=input('Input the lower bound:');% min=-100;%搜索下界
gMax=input('Input the Gen:');%代数
indexFun=input('Input the type of TestFuntion:');%测试函数类型

for j=1:runtime
    bestValue(j)=JADE_demo(max,min,gMax,indexFun);
end
mean_bestValue=mean(bestValue);%平均值
std_bestValue=std(bestValue);%标准差
disp(strcat('第',num2str(indexFun),'个函数平均值、标准差结果分别为：mean=',num2str(mean_bestValue),' , std=',num2str(std_bestValue)));
% end

toc()
