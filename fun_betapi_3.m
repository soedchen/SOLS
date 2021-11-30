function betapi = fun_betapi_3(chl,lambda)
% FUN_BETAPI_3 Calculate backscatter coefficient using spf(pi)*b
% USAGE:
%    betapi = fun_betapi_3(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength nm
% OUTPUTS:
%    betapi: numeric, backscatter coefficient
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

bp = fun_bp(chl,lambda);
[aw,bw]=fun_w(lambda);
b = bp+bw;
b = fun_b(chl,lambda);
betapi = b.*fun_spf(pi);

end