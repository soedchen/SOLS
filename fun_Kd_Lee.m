function Kd = fun_Kd_Lee(theta_s,a,bbw,bb)
% FUN_KD_LEE calculate Kd using Lee model (equation 5 in Lee 2013)
% USAGE:
%    fun_Kd_Lee(theta_s,a,bbw,bb)
% INPUTS:
%    theta_s: solar zenith angle in degrees
%    a: total absorption
%    bbw: backscattering coefficient of pure water
%    bb: the total backscattering coefficient
% OUTPUTS:
%    Kd: numeric, diffuse attenuation coefficient
% EXAMPLE:
%    
% HISTORY:
%    
% .. Authors: - 
Kd = (1+0.005.*theta_s).*a ...
    +(1-0.265.*bbw./bb).*4.259.*(1-0.52.*exp(-10.8.*a)).*bb;
end