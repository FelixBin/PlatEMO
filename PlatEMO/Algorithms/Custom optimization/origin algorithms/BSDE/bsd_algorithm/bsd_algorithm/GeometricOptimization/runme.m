

% non-optimized code and "not published" work
% tutorial for the solution of "polygon filling problem" (i.e., 2D sensor deployment problem)  by using the technique "geometric evolution"  and BSD algorithm

close all
p=[   0.64144      0.72558;
      0.70479      0.66998;
      0.58103      0.48026;
      0.51915      0.49498;
      0.56041      0.37231;
      0.62376      0.41974;
      0.64733      0.51951;
      0.74015      0.64381;
       0.8035      0.59801;
      0.62228       0.3396;
      0.48085      0.31016;
      0.48969      0.28236;
      0.58692      0.27091;
      0.50442      0.14334;
      0.36446      0.30362;
      0.38066      0.33143;
      0.42781       0.3396;
      0.42044      0.38867;
      0.28048      0.38049;
      0.17145      0.51297;
      0.23628      0.52932;
      0.24365      0.58002;
      0.18913      0.57021;
      0.21565      0.64871;
      0.30994      0.62255;
      0.35414      0.67161;
      0.44254      0.65035;
      0.45138      0.50479;
      0.47495      0.57512;
      0.53978      0.58657;
      0.52505       0.6896;
      0.58692      0.67488];

  
q=polyshape(p(:,1),p(:,2));  

mydata.polygon=q;

% rng(100)   % use for fixed experimental simulations (not optimized)


warning('off')
q=polyshape(p(:,1),p(:,2));
qnew=q;
t=-pi:.1:pi; x0=sin(t)'; y0=cos(t)';
e=[];
say=1;
while 1 
    [i say]
    algo_bsd('fit2circle',mydata,5,3,0,1,500)
    
    [err,jp]=fit2circle(outAlgo.globalminimizer,mydata);
    
    if abs(err)<0.10  % use a simple error threshold if needed (not optimized)
        e{say} = jp;        
        qnew = subtract(qnew,jp);        
        mydata.polygon= qnew;
        say=say+1;
    end
    
    if say>50, break; end   % specified number of circles is 50 for demo (you can change this value)
end

% plot filled polygon with circles , see tutorial image
for i=1:numel(e), plot(e{i});hold on;end
plot(q), daspect([1 1 1]);
shg




