%{

clear all
load('lena256.mat')
mydata.img=double(lena);
my_search('my_logcontrast', mydata, 10, 1 ,-255, 255, 1000);
[err,imj,e0] = my_logcontrast(out.globalminimizer,mydata);
imshow( [ lena imj]), shg


%}


function [out,imj,e0] = my_logcontrast(X,mydata)
img=mydata.img;
n=size(X,1);
out=rand(n,1);
for i = 1:n
    a = X(i,1);
    imj = log_contrast(img,a);
    e0 = entropy(uint8(imj));
    out(i) = -e0;
end

return

function out=log_contrast(img,A)

img=double(img);
a=double(minmax(img(:)')') ;b=a(2);a=a(1);
img=img/b;
img=padarray(img,[51 51],'symmetric');
[N,M]=size(img);
out=img;
for i=52:N-50
    for j=52:M-50
        
       
        c = A*log(img(i,j)+1);
        
        out(i,j) =c;
        
    end
end

out=ceil(255*out(52:end-51,52:end-51));
out=uint8(out);












