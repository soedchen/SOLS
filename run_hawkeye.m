clear;close all;clc;
addpath(genpath(pwd));
%% load para
Z=40;  
chl = 0.1;
ZZ=50;
H = 200;      
E0 = 3e-3;      
Bf = 142E6; 
A = 0.025;
O = 1;            
v =  2.99793e8;
omega = 30E-3;     
delta_lambda = 1; 
n = 1.333;           
eta = 0.3;          
k = 0.9;          
h = 6.626E-34;     
delta_t = 7E-9;  
lambda = 532E-9;   
nu = v/lambda;      
m = 1;            
Id = 1E-8;    
q = 1.602E-19;   
tilt_ang=20;       
theta_0=tilt_ang/180*pi;
costhe_0=cos(theta_0);
thetaw = asin(sin(theta_0)/n); % 水中入射角
costhe_w = cos(thetaw);

Rb=0.05;      
G = 3;        
Rlambda = 0.3; 
%% surface model 1
m = cos(theta_0);
g = sqrt(m.^2+n^2-1);
Fr =  0.5*(g-m).^2./(g+m).^2.*(1+(m*(g+m)-1).^2./(m*(g-m)+1).^2);
Ts=1-Fr;
%% surface Hu model for wind driven rough sea
% U=1;
% Fr=Hu_method(U,theta_0);                 %海表反射率
% Ts=1-Fr;


%% 时间转换
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
% Abdallah method
lambda = 532;Ta = fun_Ta(lambda);
k_lidar = fun_Kd_Morel(chl,lambda);
beta_pi = fun_betapi_1(chl,lambda);
Ib = fun_Lb(lambda,0);
[Ps_532,Ps_conv_532] = fun_Nss(t,E0,A,O,Ta,Fr,k,eta,n,v,delta_t,H,costhe_0);
[Pc_conv_532] = fun_Nwc(t,E0,A,O,Ta,Ts,k,eta,n,v,delta_t,H,beta_pi,k_lidar,costhe_0,costhe_w,cw,Z);
[Pb_532,Pb_conv_532] = fun_Nsf(t,E0,A,O,Ta,Ts,k,eta,n,v,H,Z,Rb,k_lidar,costhe_0,costhe_w,delta_t);
[Pbg_532,Pbg_conv_532] = fun_Nbgp(t,Ib,A,delta_lambda,k,eta,omega,Ts,Ta);
Pn_532 = fun_Ndn(Bf,Ps_conv_532,Pc_conv_532,Pb_conv_532,Pbg_conv_532,G,Id,Rlambda);
Pt_532=Ps_conv_532+Pc_conv_532+Pb_conv_532+Pbg_conv_532+Pn_532;
%% 画图
f1 = figure;
% 色系
cs = ones(1,3);
cs(1,:)=fun_s2c(532);

subplot(321);plot(z,Ps_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
xlabel("Depth (m)");ylabel("Power (W)");title("Surface return");xlim([z_start ZZ])

subplot(322);plot(z,Pbg_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
xlabel("Depth (m)");ylabel("Power (W)");title("Solar noise");xlim([z_start ZZ])

subplot(323);plot(z,Pc_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
xlabel("Depth (m)");ylabel("Power (W)");title("Column return");xlim([z_start ZZ])

subplot(324);plot(z,Pn_532,'color',cs(1,:),'linewidth',1.2);hold on
xlabel("Depth (m)");ylabel("Power (W)");title("Detector noise");xlim([z_start ZZ])

subplot(325);plot(z,Pb_conv_532,'color',cs(1,:),'linewidth',1.2);hold on
xlabel("Depth (m)");ylabel("Power (W)");title("Bottom return");xlim([z_start ZZ])

subplot(326);semilogy(z,abs(Pt_532),'color',cs(1,:),'linewidth',1.2);hold on
xlabel("Depth(m)");ylabel("Power (W)");title("Total return");xlim([z_start ZZ]);
ylim([1e-8 max(max(Pt_532))])
print('-f1','-djpeg','-r600','Hawkeye')


% subplot(3,3,[3 6 9])
% 
% %plot(z,Pt_pho);
% semilogy(z,abs(Pt_pho))
% ylim([0,max(Pt_pho)]);
% xlabel("Depth(m)");ylabel("Received photons");title("Total return photons");
% xlim([-10 80])


%% 画图
% figure;
% subplot(321);plot(t,Ps_conv);
% xlabel("Time(s)");ylabel("Power(W)");title("Surface return");
% subplot(322);plot(t,Pbg_conv);
% xlabel("Time(s)");ylabel("Power(W)");title("Solar noise");
% subplot(323);plot(t,Pc_conv);
% xlabel("Time(s)");ylabel("Power(W)");title("Column return");
% subplot(324);plot(t,Pn);
% xlabel("Time(s)");ylabel("Power(W)");title("Detector noise");
% subplot(325);plot(t,Pb_conv);
% xlabel("Time(s)");ylabel("Power(W)");title("Bottom return");
% subplot(326);plot(t,Pt);
% xlabel("Time(s)");ylabel("Power(W)");title("Total power return");

% figure;
% subplot(321);plot(z,Ps_conv);
% xlabel("Depth(m)");ylabel("Power(W)");title("Surface return");
% subplot(322);plot(z,Pbg_conv);
% xlabel("Depth(m)");ylabel("Power(W)");title("Solar noise");
% subplot(323);plot(z,Pc_conv);
% xlabel("Depth(m)");ylabel("Power(W)");title("Column return");
% subplot(324);plot(z,Pn);
% xlabel("Depth(m)");ylabel("Power(W)");title("Detector noise");
% subplot(325);plot(z,Pb_conv);
% xlabel("Depth(m)");ylabel("Power(W)");title("Bottom return");
% subplot(326);plot(z,Pt);
% xlabel("Depth(m)");ylabel("Power(W)");title("Total power return");
