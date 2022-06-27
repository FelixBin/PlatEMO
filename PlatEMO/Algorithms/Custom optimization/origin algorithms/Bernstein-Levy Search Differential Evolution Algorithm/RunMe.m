
% 1 <= FNCNO <=60
FNCNO = 1 ; 
set_fnc_settings(FNCNO); 
out = algo_bde(fnc,[],30,dim,low,up,10e3);
