clear all
load('lena256.mat')
mydata.img=double(lena);

rng(100) ; % you can replace this value for each experiment

algo_bsd('my_logcontrast', mydata, 10, 1 ,-255, 255, 200);
[err,imj,e0] = my_logcontrast(outAlgo.globalminimizer,mydata);

subplot(1,2,1), imshow(lena), xlabel(['Entropy :' num2str(entropy(lena))]); title('original image')
subplot(1,2,2), imshow(imj),  xlabel(['Entropy :' num2str(entropy(imj))]) ; title([{'log-contrast'} {'enhanced img.'}])
shg
