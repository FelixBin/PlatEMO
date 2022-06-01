
%% Culture：文化空间结构 struct{Position:[] ;Cost:[]  }
%% spop：精英个体数 []
%%遍历个体 遍历个体里面每一个子量
function Culture = AdjustCulture(Culture, spop)

n = numel(spop);%返回数组spop中元素个数
nVar = numel(spop(1).Position);%每个个体对应的位置数量（区间内x个数）

%遍历个体
for i = 1:n  %选定的精英个体数目
    
    if spop(i).Cost<Culture.Situational.Cost
        Culture.Situational = spop(i);
    end
    
    %遍历个体里面每一个子量
    for j = 1:nVar %区间内x个数
        if spop(i).Position(j)<Culture.Normative.Min(j) ...
                || spop(i).Cost<Culture.Normative.L(j)
            Culture.Normative.Min(j) = spop(i).Position(j);
            Culture.Normative.L(j) = spop(i).Cost;
        end
        if spop(i).Position(j)>Culture.Normative.Max(j) ...
                || spop(i).Cost<Culture.Normative.U(j)
            Culture.Normative.Max(j) = spop(i).Position(j);
            Culture.Normative.U(j) = spop(i).Cost;
        end
    end
end

Culture.Normative.Size = Culture.Normative.Max-Culture.Normative.Min;

end