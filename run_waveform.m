clear;close all;clc;
addpath(genpath(pwd));
%% paramaters
Z=40;chl = 0.1;
H = 400E3;E0 = 1.3;Bf = 100E6;FD = 1.5;A = pi.*(FD/2).^2;
O = 1;v =  2.99793e8;FOV = 1.5E-3;delta_lambda = 0.1; 
n = 1.333; eta = 0.5;k = 0.9; h = 6.626E-34; 
delta_t = 5E-9;lambda = 532E-9; nu = v/lambda;
m = 1;div = 5e-5;D = 2*H*tan(div/2); Id = 1E-9;
q = 1.602E-19; tilt_ang=0;
theta_0=tilt_ang/180*pi;
costhe_0=cos(theta_0);
thetaw = asin(sin(theta_0)/n); 
costhe=cos(thetaw);
Rb=0.1;G = 3; 
Rlambda = 0.33;
%% surface model 1
m = cos(theta_0);
g = sqrt(m.^2+n^2-1);
Fr =  0.5*(g-m).^2./(g+m).^2.*(1+(m*(g+m)-1).^2./(m*(g-m)+1).^2);
Ts=1-Fr;

%% time-depth
z_start=-10;
z_end=100;
ts = 2*H./(v.*cos(theta_0))*1e9;
cw = v/n;
tb = ts+(2*Z/(cw*cos(thetaw)))*1e9;
t_start=ts+(2*z_start/(v*cos(theta_0)))*1e9;
t_end=ts+(2*z_end/(cw*cos(thetaw)))*1e9;
delta_T=1/(Bf)*1e9;
t = (t_start:delta_T:t_end)*1e-9;
z_p=(0:0.5*cw*cos(thetaw)*delta_T*1e-9:z_end);
z_n=(z_start:0.5*v*cos(theta_0)*delta_T*1e-9:0);
t_size=size(z_p,2)+size(z_n,2);
t0_size=size(t,2);
if(t_size==t0_size)
    z=[z_n,z_p];
else
    z=[z_n(1:end-1),z_p];
end

%% 532nm
lambda = 530;Ta = fun_Ta(lambda);
Kd = fun_Kd_Morel(chl,lambda);
c = fun_c(chl,lambda);
beta_pi = fun_betapi_1(chl,lambda);
k_lidar=fun_Klidar(Kd,c,D);
Ib = fun_Lb(lambda,0);
[Ps_532,Ps_conv_532] = fun_Nss(t,E0,A,O,Ta,Fr,k,eta,n,v,delta_t,H,costhe);
[Pc_conv_532] = fun_Nwc(t,E0,A,O,Ta,Ts,k,eta,n,v,delta_t,H,beta_pi,k_lidar,costhe,costhe_0,cw,Z);
[Pb_532,Pb_conv_532] = fun_Nsf(t,E0,A,O,Ta,Ts,k,eta,n,v,H,Z,Rb,k_lidar,costhe,costhe_0,delta_t);
[Pbg_532,Pbg_conv_532] = fun_Nbgp(t,Ib,A,delta_lambda,k,eta,FOV,Ts,Ta);
Pn_532 = fun_Ndn(Bf,Ps_conv_532,Pc_conv_532,Pb_conv_532,Pbg_conv_532,G,Id,Rlambda);
Pt_532=Ps_conv_532+Pc_conv_532+Pb_conv_532+Pbg_conv_532+Pn_532;
%% 486nm
lambda = 490;Ta = fun_Ta(lambda);
Kd = fun_Kd_Morel(chl,lambda);
c = fun_c(chl,lambda);
beta_pi = fun_betapi_1(chl,lambda);
Ib = fun_Lb(lambda,0);
k_lidar=fun_Klidar(Kd,c,D);
[Ps_486,Ps_conv_486] = fun_Nss(t,E0,A,O,Ta,Fr,k,eta,n,v,delta_t,H,costhe);
[Pc_conv_486] = fun_Nwc(t,E0,A,O,Ta,Ts,k,eta,n,v,delta_t,H,beta_pi,k_lidar,costhe,costhe_0,cw,Z);
[Pb_486,Pb_conv_486] = fun_Nsf(t,E0,A,O,Ta,Ts,k,eta,n,v,H,Z,Rb,k_lidar,costhe,costhe_0,delta_t);
[Pbg_486,Pbg_conv_486] = fun_Nbgp(t,Ib,A,delta_lambda,k,eta,FOV,Ts,Ta);
Pn_486 = fun_Ndn(Bf,Ps_conv_486,Pc_conv_486,Pb_conv_486,Pbg_conv_486,G,Id,Rlambda);
Pt_486=Ps_conv_486+Pc_conv_486+Pb_conv_486+Pbg_conv_486+Pn_486;
%% 440nm
lambda = 440;Ta = fun_Ta(lambda);
k_lidar = fun_Kd_Morel(chl,lambda);
beta_pi = fun_betapi_1(chl,lambda);
Ib = fun_Lb(lambda,0);
[Ps_440,Ps_conv_440] = fun_Nss(t,E0,A,O,Ta,Fr,k,eta,n,v,delta_t,H,costhe);
[Pc_conv_440] = fun_Nwc(t,E0,A,O,Ta,Ts,k,eta,n,v,delta_t,H,beta_pi,k_lidar,costhe,costhe_0,cw,Z);
[Pb_440,Pb_conv_440] = fun_Nsf(t,E0,A,O,Ta,Ts,k,eta,n,v,H,Z,Rb,k_lidar,costhe,costhe_0,delta_t);
[Pbg_440,Pbg_conv_440] = fun_Nbgp(t,Ib,A,delta_lambda,k,eta,FOV,Ts,Ta);
Pn_440 = fun_Ndn(Bf,Ps_conv_440,Pc_conv_440,Pb_conv_440,Pbg_conv_440,G,Id,Rlambda);
Pt_440=Ps_conv_440+Pc_conv_440+Pb_conv_440+Pbg_conv_440+Pn_440;
%% plot
f1 = figure;

ZZ=50; % zlim
cs = ones(1,3);
cs(1,:)=fun_s2c(532);
cs(2,:)=fun_s2c(486);
cs(3,:)=fun_s2c(440);
subplot(321);plot(z,Ps_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
plot(z,Ps_conv_486,'color',cs(2,:),'linewidth',1.2);
plot(z,Ps_conv_440,'color',cs(3,:),'linewidth',1.2);
legend('530 nm','490 nm','440 nm');
xlabel("Depth (m)");ylabel("Power (W)");title("Surface return");xlim([-10 ZZ])

subplot(322);plot(z,Pbg_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
subplot(322);plot(z,Pbg_conv_486,'color',cs(2,:),'linewidth',1.2)
subplot(322);plot(z,Pbg_conv_440,'color',cs(3,:),'linewidth',1.2)
xlabel("Depth (m)");ylabel("Power (W)");title("Solar noise");xlim([-10 ZZ])

subplot(323);plot(z,Pc_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
subplot(323);plot(z,Pc_conv_486,'color',cs(2,:),'linewidth',1.2)
subplot(323);plot(z,Pc_conv_440,'color',cs(3,:),'linewidth',1.2)
xlabel("Depth (m)");ylabel("Power (W)");title("Column return");xlim([-10 ZZ])

subplot(324);plot(z,Pn_532,'color',cs(1,:),'linewidth',1.2);hold on
subplot(324);plot(z,Pn_486,'color',cs(2,:),'linewidth',1.2)
subplot(324);plot(z,Pn_440,'color',cs(3,:),'linewidth',1.2)
xlabel("Depth (m)");ylabel("Power (W)");title("Detector noise");xlim([-10 ZZ])

subplot(325);plot(z,Pb_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
subplot(325);plot(z,Pb_conv_486,'color',cs(2,:),'linewidth',1.2)
subplot(325);plot(z,Pb_conv_440,'color',cs(3,:),'linewidth',1.2)
xlabel("Depth (m)");ylabel("Power (W)");title("Bottom return");xlim([-10 ZZ])

subplot(326);plot(z,abs(Pt_532),'color',cs(1,:),'linewidth',1.2);hold on
subplot(326);plot(z,abs(Pt_486),'color',cs(2,:),'linewidth',1.2)
subplot(326);plot(z,abs(Pt_440),'color',cs(3,:),'linewidth',1.2)
xlabel("Depth(m)");ylabel("Power (W)");title("Total return");xlim([-10 ZZ])
print('-f1','-djpeg','-r600','Fig2')

