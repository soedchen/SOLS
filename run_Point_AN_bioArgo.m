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
filename = '.\bioArgo\1902303\profiles\BD1902303_046.nc';
[z_chl,chla,lat,lon,time,info]=fun_readBioArgo(filename);
idx = ~isnan(z_chl);

z = 0:delta_z:Z;
chl = interp1(z_chl(idx),chla(idx),z,'linear','extrap');
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
plot(chla,-z_chl,'*',chl,-z);ylim([-100 0])
figure;
ax(1) = subplot(121);
plot(chla,-z_chl,'b','LineWidth',1.2)  %plot(k_lidar,-z) 
ylim([-50 0]);
ylabel("Depth (m)",'FontSize',10);xlabel("Chl (mg/m^3)",'FontSize',10);
ax(2) = subplot(122);
f = ax(2).Parent;f.Position = [429.4444  381.4444  743.1111  432.8889];
pt1 = [];
for i=1:length(lambdas)
    color = fun_s2c(lambdas(i));
    if lambdas(i)==490 
        color = [1,0,0];
    end
    pt1(i)=semilogx(ax(2),Ps(i,:),-z,'-','color',color,'linewidth',1.2);hold on
   % a = 0.3;[~,ind]=min(abs(SNRd(i,:)-1/a));plot([z(ind) z(ind)],[0 1/a],'--','color','k');yline(1/a,'--');
end

% yline(1/0.3,'.');%ylim(ax(1),[1, max([max(max(SNRd)),max(max(SNRn))])]);
%ax(1).Position = ax(1).Position-[0.05 0 0 0];
pos = ax(1).Position;
ylabel("Depth (m)",'FontSize',10);xlabel("Echo signal (W)",'FontSize',10);
% text(2,19.7,'(a)'); % 
lg1 = legend([pt1], {"440nm","490 nm","530 nm"});
    set(lg1,'edgecolor','none','Color','none','FontSize',10);

print(gcf,'-djpeg','-r600','bio-argo')