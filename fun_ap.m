function ap= fun_ap(chl,lambda)
% FUN_AP calculate the particle absorption using equation(6) in HE5TechDoc.pdf
%        A E in newCase1COEF.txt used in HE5 (hydrolight)
% USAGE:
%    ap = fun_ap(chl,lambda)
% INPUTS:
%    chl: numeric, chlorophyll concentration mg/m3
%    lambda: numeric, wavelength, nm
% OUTPUTS:
%    ap: numeric, absorption coeficient of particle
% EXAMPLE:
%    ap= fun_ap(1,532)
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

chl_COE = load('ChlCOEF.mat');
lambda_ = chl_COE.lambda;
Ap = chl_COE.Ap;
Ep = chl_COE.Ep;
A = interp1(lambda_,Ap,lambda);
E = interp1(lambda_,Ep,lambda);
ap = A.*chl.^E;
end