clear;close all;clc
addpath(genpath(pwd));
O=1;To = 0.45;Ts = 0.95;H = 500E3;delta_t = 1.3E-9;n = 1.33;
E0 = 924e-6; 
A = 0.41;FOV = 83.5E-6; delta_lambda = 38e-3;deadtime=3.2e-9; 
eta = 0.15;Ta =0.7;W=6;theta=0.3*pi/180;
m =ceil(2125.3/7000*10000);
Nd = 1000;
e = 1.602e-19;
h = 6.626E-34;
v =  2.99793e8;
Z = 35.4;

delta=200e-12;
thr = 1/0.3;
lambda = [532];
Rb=0.1; 
chl = [0.1]';
day = false; % night
[m_pc,z_pc,Prb,z,t,In,Nz] = fun_PC(E0,A,FOV,O,To,Ta, ...
    Ts,eta,n,H,v,delta_t,theta,delta,delta_lambda,Z,lambda,chl,Rb,W,Nd,deadtime,m,day);
% figure;
% subplot(121);semilogx(Nt,-z,'b','LineWidth',1.2);
% xlabel('N_{T}(t) (Hz)'),ylabel("Depth (m)")
% subplot(122);semilogx(In,-z,'b','LineWidth',1.2)
% xlabel('I(n) count'),ylabel("Depth (m)")
figure;
subplot(221)
plot(m_pc,-z_pc,'.');ylim([-40 5])
xlabel("Simulation number");ylabel("Depth (m)")
subplot(222)
% semilogx(Nz,-z);
% 

% figure;
dh = 0.1;
h = min(z):dh:max(z);
N = zeros(size(h));
for i=1:length(h)
    N(i)=sum((z_pc>(h(i)-dh/2) & z_pc<(h(i))+dh/2));
end
plt=semilogx(N,-h);ylim([-40 5])
xlabel("Number of photons");ylabel("Depth (m)")
ax = plt.Parent;
ax.XTick=[1 10 100 1000];
% print(gcf,'-djpeg','-r600','PC3')

file = "ATL03_20181122060325_08340107_004_01.h5";
info = h5info(file);
vars = {'gt1l','gt1r','gt2l','gt2r','gt3l','gt3r'};
var = vars{4};
datasets = {'delta_time','dist_ph_across','dist_ph_along','h_ph','lat_ph','lon_ph','ph_id_channel'};
% h5disp(file,'/gt1l/heights/lat_ph')
data = 'lat_ph';
lat_ph = h5read(file,['/' var '/heights/' data]);
data = 'lon_ph';
lon_ph=h5read(file,['/' var '/heights/' data]);
data = 'h_ph';
h_ph=h5read(file,['/' var '/heights/' data]);
data = 'dist_ph_along';
dist_ph_along=h5read(file,['/' var '/heights/' data]);
data = 'delta_time';
delta_time=h5read(file,['/' var '/heights/' data]);
data = 'dist_ph_across';
dist_ph_across=h5read(file,['/' var '/heights/' data]);
% plot(lat_ph,h_ph,'.','MarkerSize',4);
% xlim([18.24 18.32])
% ylim([-110 -20])
% figure;plot(lon_ph,lat_ph)

% 筛选
lat_low = 18.281;lat_up=18.3;
idx = lat_ph>lat_low & lat_ph< lat_up;
lon_low = min(lon_ph(idx));lon_up=max(lon_ph(idx));
S = 2*asin(sqrt(sin((lat_up-lat_low)./2*pi/180).^2+cos(lat_low*pi/180)* ...
    cos(lat_up*pi/180)*sin((lon_up-lon_low)./2*pi/180).^2))*6378.137*1000;
data = h_ph(idx);
h_low = min(data);h_up=max(data);
dh = 0.1;
h = h_low:dh:h_up;
N = zeros(size(h));
for i=1:length(h)
    N(i)=sum((data>(h(i)-dh/2) & data<(h(i))+dh/2));
end
h0=-44; % -44
sum(idx)
% figure
subplot(223);plot(lat_ph(idx),h_ph(idx)-h0,'.');ylim([-40 5])
xlabel("Latitude ");ylabel("Depth (m)")
subplot(224);plt = semilogx(N,h-h0,'-');ylim([-40 5]);%xlim([1e-0 105])
xlabel("Number of photons");ylabel("Depth (m)")
ax = plt.Parent;
ax.XTick=[1 10 100 1000];
