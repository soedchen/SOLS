function [SNR,Zmax_snr] = fun_SNR_PC(m,Ns,Nb,Nd,delta_t,thr,z)
% FUN_SNR_PC calculate SNR using photon counting mode
% USAGE:
%   [SNR,Zmax_snr] = fun_SNR_PC(m,Ns,Nb,Nd,delta_t,thr,z)
% INPUTS:
%   m: the number of laser shots integrated
%   Ns: the photon-count number of the received scattering signal
%   Nb: the recievced number of photon counts that is due to diffuse radiation
%   Nd: dark count rate
%   delta_t: pulse width
%   thr: threshold value of SNR
%   z: depth vector
% OUTPUTS:
%   SNR: numeric, SNR
%   Zmax_snr: the maximum depth where SNR begins to be less than thr
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

[row,col,num] = size(Ns);
Nb_3 = repmat(Nb',1,row,col);
Nb_3 = permute(Nb_3,[2,3,1]);
delta_N = sqrt(Ns+Nb_3+Nd.*delta_t);
SNR = sqrt(m).*Ns./delta_N;
[~,ind] = max((SNR<thr),[],2);
Zmax_snr = z(ind);
if ndims(Zmax_snr)==2
    Zmax_snr =Zmax_snr';
else
    Zmax_snr = permute(Zmax_snr,[1 3 2]);
end

end




