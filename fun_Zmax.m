function [Zmax_ns,Zmax_snrd,Zmax_snrn,l_ns,l_snrd,l_snrn] = fun_Zmax(lambdas,chls,params)
% FUN_ZMAX calculate maximum detectable depth and corresponding optimal wavelength
%               with chl dataset(m*n) by calling fun_Zmax_one
% USAGE:
%    [Zmax_ns,Zmax_snrd,Zmax_snrn,l_ns,l_snrd,l_snrn] = fun_Zmax(lambdas,chls,params)
% INPUTS:
%    lambdas: a row of lambdas
%    chls: chl dataset (m*n)
%    params: lidar systems [O,To,Ts,H,E0,B,D,A,FOV,delta_lambda,n,R,Fm,Id,
%       delt_t,v,Lb,thea,theta_w,Z,m,thr,M]
% OUTPUTS:
%    Zmax_ns: depth where N=1;
%    Zmax_snrd: maximum depth with thr during daytime
%    Zmax_snrn: maximum depth with thr during nighttime
%    l_ns: Corresponding optimal wavelength of Zmax_ns
%    l_snrd: Corresponding optimal wavelength of Zmax_snrd
%    l_snrn: Corresponding optimal wavelength of Zmax_snrn

[m,n]=size(chls);
Zmax_ns = zeros(m,n);
Zmax_snrd = zeros(m,n);
Zmax_snrn = zeros(m,n);
l_ns = zeros(m,n);
l_snrd = zeros(m,n);
l_snrn = zeros(m,n);
for j = 1:n
    disp(['chl: ' num2str(j) '/' num2str(n)])
    chl = chls(:,j);
   [Zmax_ns(:,j),Zmax_snrd(:,j),Zmax_snrn(:,j),l_ns(:,j),l_snrd(:,j),l_snrn(:,j)]=fun_Zmax_one(lambdas,chl,params);
   
end
end


