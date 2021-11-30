clear;close all;clc
addpath(genpath(pwd));
% system paramaters
O=1;To = 0.9;Ts = 0.95;H = 400E3;delta_t = 7.2E-9;n = 1.33;
E0 = 1.3;B = 200E6;D = 1.5;A = pi.*(D/2).^2;
FOV = 0.15E-3; delta_lambda = 1;
R = 0.45;F = 4;M = 100;Id = 1.31e-12;
e = 1.602e-19;h = 6.626E-34;v =  2.99793e8;
theta = 0;theta_w = 0;W=5.6;
Z = 50;
m =1;thr = 1/0.3;Fm=F;
delta_z = 0.1;
winLen = 8/delta_z;

lambdas = [440 490 530];
% lambdas = 440;
c0 = 1;
c1 = 0.5;
zm = 10;
sigma = 5;
chl_fun = @(z) (c1+c0*exp(-(z-zm).^2./(2.*sigma.^2)));
% chl = [0.1]';

z = 0:delta_z:Z;
chl = chl_fun(z);
Ta = 0.7;
Lb = fun_Lb(lambdas,0);
nu = v./(lambdas*1E-9);
k_lidar = fun_Kd_Morel(chl',lambdas)';
[beta_pi] = fun_betapi_1(chl',lambdas)';
[Ps,Ns,Zmax_ns] =  fun_Ps_pfl(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w);
[Pb,Nb] = fun_Pb(Lb,A,FOV,R,delta_lambda,To,delta_t,nu);
SNRtype = 1;
[SNRd,Zmaxs_snrd] = fun_SNR_AN_pfl(m,Ns,Nb,Fm,Id,delta_t,M,thr,z,SNRtype,winLen);
[SNRn,Zmaxs_snrn] = fun_SNR_AN_pfl(m,Ns,0,Fm,Id,delta_t,M,thr,z,SNRtype,winLen);

ax(2) = subplot(122);
plot(k_lidar,-z,'LineWidth',1.2)
xlabel('K_{lidar} (m^{-1})');ylabel('Depth (m)')
ax(1) = subplot(121);
f = ax(1).Parent;f.Position = [429.4444  381.4444  743.1111  432.8889];
pt1 = [];
for i=1:length(lambdas)
    color = fun_s2c(lambdas(i));
    if lambdas(i)==490 
        color = [1,0,0];
    end
    pt1(i)=semilogx(ax(1),Ps(i,:),-z,'-','color',color,'linewidth',1.2);hold on
end
pos = ax(1).Position;

ylabel("Depth (m)",'FontSize',10);xlabel("Ps (W)",'FontSize',10);
print(gcf,'-djpeg','-r600','chlpfl')
