

load FncData

%  see benchmark_fnc_list.pdf for the list of the benchmark functions and 'fncnumber'

fncnumber=1; 

fnc=Fnc{fncnumber}; %索引对应的函数名称
low=FncLow(fncnumber); %某个函数对应的下界
up=FncUp(fncnumber); %某个函数对应的上界
dim=FncDim(fncnumber);%某个函数对应的维度
algo_bsd(fnc,[],48,30,low,up,100) %absolute -100  100 dim=30



