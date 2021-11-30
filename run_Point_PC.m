clear;close all;clc
addpath(genpath(pwd));
% system paramaters
O=1;To = 0.45;Ts = 0.95;H = 500E3;delta_t = 1.3E-9;n = 1.33;
E0 = 92.4e-6;B = 200E6;A = 0.41;
FOV = 83.5E-6; delta_lambda = 38e-3;
R = 0.15;F = 4;M = 1;Nd = 1000;
e = 1.602e-19;h = 6.626E-34;v =  2.99793e8;
theta = 0;theta_w = 0;W=5.6;
Z = 300;
m =100000;thr = 1/0.3;Fm=F;
delta_z = 0.1;
lambdas = [532];
chl = [1]';
z = 0:delta_z:30;
Ta = 0.7;
Lb = fun_Lb(lambdas,0);
nu = v./(lambdas*1E-9);
k_lidar = fun_Kd_Morel(chl,lambdas);
[beta_pi] = fun_betapi_1(chl,lambdas);
[Ps,Ns,Zmax_ns] =  fun_Ps(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w);
[Pb,Nb] = fun_Pb(Lb,A,FOV,R,delta_lambda,To,delta_t,nu);
[SNRd,Zmax_snrd] = fun_SNR_PC(m,Ns,Nb,Nd,delta_t,thr,z);
[SNRn,Zmax_snrn] = fun_SNR_PC(m,Ns,0,Nd,delta_t,thr,z);
gammaS = fun_gammaS(W,theta);
[Pss,Nss] = fun_Pss(E0,A,O,To,Ta,R,delta_t,H,nu,gammaS,theta,k_lidar);
% Ns(1)=Nss;
Prb = fun_Prb(Ns);
% semilogy(z,Ns,z,Prb);
track = [];
valid = [];
data =zeros(length(z),m);
for i=1:m
    for j=1:length(z)
        tmp = fun_randsrc(Prb(j));
        if(tmp==1)
           track = [track i];
           valid = [valid z(j)];
           data(j,i)=1;
        end  
    end
end
figure;
subplot(121)
plot(track,-valid,'.')
subplot(122)
semilogx(sum(data,2),-z);
