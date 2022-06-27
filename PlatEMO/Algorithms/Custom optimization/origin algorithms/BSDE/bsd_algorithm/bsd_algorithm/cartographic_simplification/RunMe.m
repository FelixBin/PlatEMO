load('cities.mat')
x=A(48).X;  % kayseri  latitude,  see cities.JPG
y=A(48).Y;  % kayseri  longitute, see cities.JPG
data=[x' y'];



mydata.xy=data;
fnc=cscvn(data');
mydata.fnc=fnc;
mydata.K=10;  %  predefined tie-points

dim=mydata.K;
fnc=cscvn(data');
l=minmax(fnc.breaks);
algo_bsd('my_simplified_geometry',mydata,10, dim ,l(1),l(2),100);


[out,xy0]=my_simplified_geometry(outAlgo.globalminimizer,mydata);

x=mydata.xy(:,1); y=mydata.xy(:,2);
plot(x,y); hold on, plot(xy0(:,1),xy0(:,2),'.'),shg
hold on

xy0(end+1,:)=xy0(1,:);
fnc2=cscvn(xy0');
fnplt(fnc2,[0 fnc2.breaks(end)])
xlabel('latitute')
ylabel('longitute')
plot(xy0(:,1),xy0(:,2),'.r','markersize',15)
shg




