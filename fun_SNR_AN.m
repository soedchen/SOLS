function [SNR,Zmax_snr] = fun_SNR_AN(m,Ps,Pb,Fm,Id,delta_t,M,thr,z,SNRtype,winLen)
% FUN_SNR_AN calculate SNR using analog detection mode
% USAGE:
%   [SNR,Zmax_snr] = fun_SNR_AN(m,Ns,Nb,Fm,Id,delta_t,M,thr,z)
% INPUTS:
%   m: the number of laser shots integrated
%   Ps: return signal power
%   Pb:	Background light power
%   Fm:	the excess noise factor
%   Id:	the noise current
%   M:	multiplication factor
%   thr: threshold value of SNR
%   z: depth vector
%   SNRtype: the method to calculate SNR
%       1: SNR = Ps/sqrt(Pt)
%       2: SNR = Ps/dev(Pt)
%   winLen: windows length to calculate signal uncertainty
% OUTPUTS:
%   SNR: numeric, SNR
%   Zmax_snr: the maximum depth where SNR begins to be less than thr
% EXAMPLE:
%
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: -


e = 1.602e-19; % the elementary charge
[row,col,num] = size(Ps);
Nb_3 = repmat(Pb',1,row,col);
Nb_3 = permute(Nb_3,[2,3,1]);
P_t= Fm.*(Ps+Nb_3)+Id.^2.*delta_t./(M.^2.*e.^2);	% chl * z *lambda
if SNRtype==1
    delta = sqrt(P_t);
else
    delta = fun_ADSigStd(P_t,winLen);
end
SNR = (m.^0.5*Ps./delta);
[~,ind] = max((SNR<thr),[],2);
Zmax_snr = z(ind);
if ndims(Zmax_snr)==2
    Zmax_snr =Zmax_snr';
else
    Zmax_snr = permute(Zmax_snr,[1 3 2]);
end
% [~,ind] = max((SNR<thr),[],2);
% Zmax_snr = z(ind)';
end