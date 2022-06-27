function [out,jp]=fit2circle(X,mydata)
t=-pi:.1:pi; x0=sin(t)'; y0=cos(t)';
q=mydata.polygon;
n=size(X,1);

out=rand(n,1);
for i=1:n

sol = X(i,:);
r = abs(sol(1));
f = pi*r*r;
e = r*[x0 y0]+sol(2:3);
% plot(q);hold on; plot(e(:,1),e(:,2)); shg,pause
j = ~isinterior(q,e(:,1)',e(:,2)');
jp=polyshape(e(:,1),e(:,2));

a = 10*double(sum(j)) - jp.area;
out(i)=a;


end

