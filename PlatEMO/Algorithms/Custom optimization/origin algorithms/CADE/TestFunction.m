
function [ y ] = TestFunction(type ,x)
%TESTFUNCTION 此处显示有关此函数的摘要
%   此处显示详细说明
%13类标准测试函数组成的函数文件
    if type==1
        y=sum(x.^2);
    elseif type==2
        y=sum(abs(x))+prod(abs(x));
    elseif type==3
        len = length(x);
        y = 0;
        for i=1:len
            y = y+sum(x(1:i)).^2;
        end
    elseif type==4
        y = max(abs(x));
    elseif type==5
        dimension = length(x);
        y = sum(100*(x(2:dimension)-x(1:dimension-1).^2).^2 + (1-x(1:dimension-1)).^2);
    elseif type==6
        y = sum((floor(x+0.5)).^2);
    elseif type==7
        len = length(x);
        y = 0;
        for i=1:len
           y = y+i*x(i).^4;
        end
        y = y+rand();
    elseif type==8
        D = length(x);
        y = sum(-x.*sin(sqrt(abs(x))))+418.9828872724399*D;
    elseif type==9
        y = sum(x.^2-10*cos(2*pi.*x)+10);
    elseif type==10
         D = length(x);
         y = -20*exp(-0.2*sqrt(1/D*sum(x.^2)))-exp(1/D*sum(cos(2*pi.*x)))+20+exp(1);
    elseif type==11
        len = length(x);
        y = 1/4000*sum(x.^2)-prod(cos(x(1:len)/sqrt(1:len)))+1;
    elseif type==12
        D = length(x);
        Y=funcY(x);
        u=funcU(x,10,100,4);
    
        y=1/D*pi.*( 10*(sin(pi*Y(1))).^2+sum(((Y(1:D-1)-1).^2).*(1+10.*(sin(pi.*Y(2:D))).^2))+(Y(D)-1).^2 )+sum(u);
    elseif type==13
        D = length(x);
        u = funcU(x,5,100,4);
        y = 0.1.*((sin(3*pi*x(1))).^2 +sum((x(1:D-1)-1).^2.*(1+(sin(3*pi.*(x(2:D)))).^2 )))+0.1*((x(D)-1).^2)*(1+(sin(2*pi*x(D))).^2)+sum(u);
    end
end
 
function [ y ] = funcU( x,a,k,m )
%FUNCU 此处显示有关此函数的摘要
%   此处显示详细说明 a=10 or 5, k=100,m =4
    len = length(x);
    for i=1:len
        if x(i)>a
            y(i)=k*(x(i)-a).^m;
        else if -a<=x(i)&&x(i)<=a
                y(i)=0;
            else
                y(i)=k*(-x(i)-a).^m;
            end
        end
    end
end
 
function [ y ] = funcY( x )
%FUNCY 此处显示有关此函数的摘要
%   此处显示详细说明
    y = 1+(x+1)/4;
end
