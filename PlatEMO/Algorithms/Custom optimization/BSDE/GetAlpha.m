function p = GetAlpha()
%GETALPHA 此处显示有关此函数的摘要
%   The 2nd degree Bernstain polynomials
beta = rand;
kappa = ceil( 3 * (rand.^3) );%ceil四舍五入到大于或等于该元素的最接近整数
switch kappa
    case 1
        p = beta .^ 2;
    case 2
        p = 2*(1-beta) * beta;
    case 3
        p = (1-beta) .^ 2;
end
end

