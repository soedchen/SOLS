close all;clear;clc;
addpath(genpath(pwd));
% Maximum detectable depth and corresponding optimal wavelength
tic;
file = "A20021852021031.L3m_CU_CHL_chlor_a_9km.nc";
chls = ncread(file,'chlor_a');
lon = ncread(file,"lon");
lat = ncread(file,"lat");
[LAT,LON]=meshgrid(lat,lon);


lambdas = 415:5:575;
% lambdas = [412,443,469,488,531,547,555];

O=1;To = 0.9;Ts = 0.95;H = 400E3;delta_t = 7.2E-9;n = 1.33;
E0 = 1.3;B = 200E6;D = 1.5;A = pi.*(D/2).^2;
FOV = 0.15E-3; delta_lambda = 1;
R = 0.45;F = 4;M = 100;Id = 1.31e-12;
e = 1.602e-19;h = 6.626E-34;v =  2.99793e8;
theta = 0;theta_w = 0;
Z = 300;Lb=1.4;
%% 
m =1;
thr = 1/0.7;

params = [O,To,Ts,H,E0, ... 
    B,D,A,FOV,delta_lambda, ... 
    n,R,F,Id,delta_t, ... 
    v,Lb,theta,theta_w,Z,m,thr,M];
[row,col] = size(chls);
chls = reshape(chls,[],600);  % 25 50 100 600 800
% parpool('local',1);
% gpuDevice(1);

[Zmax_ns_70,Zmax_snrd_70,Zmax_snrn_70,l_ns_70,l_snrd_70,l_snrn_70] = fun_Zmax(lambdas,chls,params);
toc
% 设置NaN
Zmax_ns_70(Zmax_ns_70==0)=NaN;
Zmax_snrd_70(Zmax_snrd_70==0)=NaN;
Zmax_snrn_70(Zmax_snrn_70==0)=NaN;
l_ns_70(isnan(Zmax_ns_70))=NaN;
l_snrd_70(isnan(Zmax_snrd_70))=NaN;
l_snrn_70(isnan(Zmax_snrn_70))=NaN;

% 重排列
chls = reshape(chls,row,col);
Zmax_ns_70 = reshape(Zmax_ns_70,row,col);
Zmax_snrd_70 = reshape(Zmax_snrd_70,row,col);
Zmax_snrn_70 = reshape(Zmax_snrn_70,row,col);
l_ns_70 = reshape(l_ns_70,row,col);
l_snrd_70 = reshape(l_snrd_70,row,col);
l_snrn_70 = reshape(l_snrn_70,row,col);

% 统计数据
sat_ns_70 = tabulate(l_ns_70(:));
sat_snrd_70 = tabulate(l_snrd_70(:));
sat_snrn_70 = tabulate(l_snrn_70(:));
save('optimumu_wavelength_70');
% plot，ns
figure;
ha = tight_subplot(1,2,0.04);
axes(ha(1));fun_plotGlobe(lon,lat,Zmax_ns_70,'Z-ns',true);
axes(ha(2));fun_plotGlobe(lon,lat,l_ns_70,'\lambda-ns',true);
% print ('-f1', '-djpeg', '-r600', "F4-Global distribution based on ns")
figure;
plot(sat_ns_70(:,1),sat_ns_70(:,3));
xlim([400 700]);grid on;grid minor
% plot，snrd snrn
figure;
ha = tight_subplot(2,2,0.04);
axes(ha(1));fun_plotGlobe(lon,lat,Zmax_snrd_70,'Zmax-snrd-100%',true);
axes(ha(2));fun_plotGlobe(lon,lat,l_snrd_70,'\lambda-snrd',true);
axes(ha(3));fun_plotGlobe(lon,lat,Zmax_snrn_70,'Zmax-snrn-100%',true);
axes(ha(4));fun_plotGlobe(lon,lat,l_snrn_70,'\lambda-snrn',true);

figure;
pl = plot(sat_ns_70(:,1),sat_ns_70(:,3),'r');hold on;
plot(sat_snrd_70(:,1),sat_snrd_70(:,3),'g*');
plot(sat_snrn_70(:,1),sat_snrn_70(:,3),'b')
ax = pl.Parent;grid on;%ax.XTick = lambdas;
legend('Ns','SNR-day','SNR-night');grid on; grid minor;
xlim([400 600])