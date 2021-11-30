clear;close all;clc
addpath(genpath(pwd));
% system paramaters
O=1;To = 0.9;Ts = 0.95;H = 400E3;delta_t = 7.2E-9;n = 1.33;
E0 = 1.3;B = 200E6;D = 1.5;A = pi.*(D/2).^2;
FOV = 0.15E-3; delta_lambda = 1;
R = 0.45;F = 4;M = 100;Id = 1.31e-12;
e = 1.602e-19;h = 6.626E-34;v =  2.99793e8;
theta = 0;theta_w = 0;
Z = 300;
m =1;thr = 1/0.3;Fm=F;
lambdas = 490;

file = "A20021852021031.L3m_CU_CHL_chlor_a_9km.nc";
chls = ncread(file,'chlor_a');
lon = ncread(file,"lon");
lat = ncread(file,"lat");
[LAT,LON]=meshgrid(lat,lon);
[row,col] = size(chls);
file = "A20021852021031.L3m_CU_KD490_Kd_490_9km.nc";
Kds = ncread(file,'Kd_490');

z = 0:1:300;
Ta = 0.7;
Lb = fun_Lb(lambdas,0);
nu = v./(lambdas*1E-9);
k_lidars = Kds;
[beta_pis] = fun_betapi_1(chls,lambdas);
%% 3 dynamic range
drange=1e3;
for i = 1:col
    disp([num2str(i),'/',num2str(col)]);
    k_lidar = k_lidars(:,i);
    beta_pi = beta_pis(:,i);
    [~,~,Zmax_dy3(:,i)] =  fun_Ps_dynamic(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w,drange);
end
%% 5 dynamic range
drange=1e5;
for i = 1:col
    disp([num2str(i),'/',num2str(col)]);
    k_lidar = k_lidars(:,i);
    beta_pi = beta_pis(:,i);
    [~,~,Zmax_dy5(:,i)] =  fun_Ps_dynamic(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w,drange);
end
%%
Zmax_dy3(Zmax_dy3==0)=NaN;
Zmax_dy5(Zmax_dy5==0)=NaN;
save('data_dynamic')
figure;
ha = tight_subplot(1,2,0.04);
set(gcf,'Position',[429.8889  189.4444  889.3333  427.3889]);
axes(ha(1));fun_plotGlobe(lon,lat,Zmax_dy3,'Z-3',true);
    hold on;text(-3.2,1.5,'(a)');text(-3.05,-2.65,'m');caxis([0 250]);
axes(ha(2));fun_plotGlobe(lon,lat,Zmax_dy5,'z-5',true);
    hold on;text(-3.2,1.5,'(b)');text(-3.05,-2.65,'m');caxis([0 250]);
print('-f1','-djpeg','-r600','F13')


figure;
[pl,cb]=fun_plotGlobe(lon,lat,log10(Kds),'',true);
caxis([-1.9 0.5]);
cb.Ticks = -1.9:0.2:0.5;
cb.TickLabels = round(10.^cb.Ticks,3);