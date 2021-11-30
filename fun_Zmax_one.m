function [Zmax_ns,Zmax_snrd,Zmax_snrn,l_ns,l_snrd,l_snrn]=fun_Zmax_one(lambdas,chl,params)
% FUN_ZMAX_ONE calculate maximum detectable depth and corresponding optimal wavelength
%               with one column chls
% USAGE:
%    [Zmax_ns,Zmax_snrd,Zmax_snrn,l_ns,l_snrd,l_snrn]=fun_Zmax_one(lambdas,chl,params)
% INPUTS:
%    lambdas: a row of lambdas
%    chl: a column of chls
%    params: lidar systems [O,To,Ts,H,E0,B,D,A,FOV,delta_lambda,n,R,Fm,Id,
%       delt_t,v,Lb,thea,theta_w,Z,m,thr,M]
% OUTPUTS:
%    Zmax_ns: depth where N=1;
%    Zmax_snrd: maximum depth with thr during daytime
%    Zmax_snrn: maximum depth with thr during nighttime
%    l_ns: Corresponding optimal wavelength of Zmax_ns
%    l_snrd: Corresponding optimal wavelength of Zmax_snrd
%    l_snrn: Corresponding optimal wavelength of Zmax_snrn

% lambdas = gpuArray(lambdas);
% chl = gpuArray(chl);
% params = gpuArray(params);
O=params(1);To = params(2);Ts = params(3);H = params(4);E0 = params(5);
B = params(6);D = params(7);A = params(8);FOV = params(9);delta_lambda = params(10);
n = params(11);R = params(12);Fm = params(13);Id = params(14);delta_t = params(15);
v =  params(16);Lb = params(17);theta = params(18);theta_w = params(19);
Z = params(20);m = params(21);thr = params(22); M = params(23);
z = 0:1:Z;
num = length(lambdas);
row = length(chl);
Zmaxs_ns = zeros(row,num);
Zmaxs_snrd = zeros(row,num);
Zmaxs_snrn = zeros(row,num);
Ta = fun_Ta(lambdas);nu = v./(lambdas*1E-9);
beta_pi = fun_betapi_1(chl,lambdas);
k_lidar = fun_Kd_Morel(chl,lambdas);
Lb=fun_Lb(lambdas,theta);
[~,Ns,Zmaxs_ns] = fun_Ps(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w);
[~,Nb] = fun_Pb(Lb,A,FOV,R,delta_lambda,To,delta_t,nu);
[~,Zmaxs_snrd] = fun_SNR_AN(m,Ns,Nb,Fm,Id,delta_t,M,thr,z,1);
[~,Zmaxs_snrn] = fun_SNR_AN(m,Ns,0,Fm,Id,delta_t,M,thr,z,1);
% Zmaxs_ns = gather(Zmaxs_ns);
% Zmaxs_snrd = gather(Zmaxs_snrd);
% Zmaxs_snrn = gather(Zmaxs_snrn);
% lambdas = gather(lambdas);
[Zmax_ns,ind]=max(Zmaxs_ns,[],2);
l_ns = lambdas(ind)';
[Zmax_snrd,ind]=max(Zmaxs_snrd,[],2);
l_snrd = lambdas(ind)';
[Zmax_snrn,ind]=max(Zmaxs_snrn,[],2);
l_snrn = lambdas(ind)';

% for i =1:num
%     if(mod(i,50)==0)
%         %disp(['lambda: ' num2str(i) '/' num2str(num)]);
%         fprintf('lambda: %4.0f/%4.0f\n',i,num);
%     end      
%     lambda = lambdas(i);
%     Ta = Ta_fun(lambda);
%     nu = v/(lambda*1E-9);
%     theta = 0;Lb=Lb_fun(lambda,theta);
%     %disp("Calculate Kd");
%     k_lidar = Kds(:,i);
%     [beta_pi,~,~,~,~] = BetaPI_fun(chl,lambda);
%     %disp("Calculate Ns");
%     [Ps,~,Zmaxs_nc(:,i)] =  Ps_fun(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w);
%     Pb = Pb_fun(Lb,A,FOV,R,delta_lambda,To);
%     %disp("Calculate SNR-day");
%     [~,Zmaxs_snrd(:,i)] = SNR_fun(m,Ps,Pb,Id,F,B,z,thr);
%     %disp("Calculte SNR-night");
%     [~,Zmaxs_snrn(:,i)] = SNR_fun(m,Ps,0,Id,F,B,z,thr);
% end
% [Zmax_ns,i]=max(Zmaxs_nc,[],2);
% l_ns = lambdas(i)';
% [Zmax_snrd,i]=max(Zmaxs_snrd,[],2);
% l_snrd = lambdas(i)';
% [Zmax_snrn,i]=max(Zmaxs_snrn,[],2);
% l_snrn = lambdas(i)';
% end
