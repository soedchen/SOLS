clear;close all;clc
addpath(genpath(pwd));
% system paramaters
O=1;To = 0.9;Ts = 0.95;H = 400E3;delta_t = 7.2E-9;n = 1.33;
E0 = 1.3;B = 200E6;D = 1.5;A = pi.*(D/2).^2;
FOV = 0.15E-3; delta_lambda = 1;
R = 0.45;F = 4;M = 100;Id = 1.31e-12;
e = 1.602e-19;h = 6.626E-34;v =  2.99793e8;
theta = 0;theta_w = 0;W=5.6;
Z = 300;
m =1;thr = 1/0.3;Fm=F;
delta_z = 0.01;
winLen = 8/delta_z;

lambdas = [440 490 530];
% lambdas = 440;
chl = [0.1]';
z = 0:delta_z:100;
Ta = 0.7;
Lb = fun_Lb(lambdas,0);
nu = v./(lambdas*1E-9);

k_lidar = fun_Kd_Morel(chl,lambdas);
[beta_pi] = fun_betapi_1(chl,lambdas);
[Ps,Ns,Zmax_ns] =  fun_Ps(E0,A,O,To,Ta,Ts,R,n,v,delta_t,H,z,nu,beta_pi,k_lidar,theta,theta_w);

[Pb,Nb] = fun_Pb(Lb,A,FOV,R,delta_lambda,To,delta_t,nu);
SNRtype = 1;
[SNRd,Zmaxs_snrd] = fun_SNR_AN(m,Ns,Nb,Fm,Id,delta_t,M,thr,z,SNRtype,winLen);
[SNRn,Zmaxs_snrn] = fun_SNR_AN(m,Ns,0,Fm,Id,delta_t,M,thr,z,SNRtype,winLen);


% plot 1
ax(2) = subplot(122);ax(1) = subplot(121);
f = ax(1).Parent;f.Position = [429.4444  381.4444  743.1111  432.8889];
pt1 = [];
for i=1:length(lambdas)
    color = fun_s2c(lambdas(i));
    if lambdas(i)==490 
        color = [1,0,0];
    end
    pt1(i)=plot(ax(1),z,SNRd(:,:,i),'-','color',color,'linewidth',1.2);hold on
    a = 0.3;[~,ind]=min(abs(SNRd(:,:,i)-1/a));plot([z(ind) z(ind)],[0 1/a],'--','color','k');yline(1/a,'--');
end
yline(1/0.3,'.');ylim(ax(1),[1, max([max(max(SNRd)),max(max(SNRn))])]);
ax(1).Position = ax(1).Position-[0.05 0 0 0];
pos = ax(1).Position;
xlabel("Depth (m)",'FontSize',10);ylabel("SNR",'FontSize',10);
text(2,19.7,'(a)'); % 
ax(3) = axes();
% %%晚上
% for i=1:length(lambdas)
%     color = fun_s2c(lambdas(i));
%     pt2(i)=plot(ax(3),z,SNRn(:,:,i),'--','color',color,'linewidth',1.2);hold on
%     a = 0.3;[~,ind]=min(abs(SNRn(:,:,i)-1/a));plot([z(ind) z(ind)],[0 1/a],'--','color','k');    
% end
set(ax(1),'XMinorGrid','on','XMinorTick','on','YMinorGrid','on','YMinorTick','on','box','off');
ylim1 = ax(1).YLim;ylim2 = ylim1;
set(ax(3),'position',ax(1).Position,'xlim',ax(1).XLim,'yaxislocation','right', ...
    'color','none','ylim',ylim2,'box','off'); % , 'YDir','reverse'
ax(3).YTick = [1/1,1/0.5, 1/0.3, 1/0.1];
ax(3).YTickLabel={"100%","50%","30%","10%"};
lg1 = legend([pt1], {"440nm","490 nm","530 nm"});
    set(lg1,'edgecolor','none','Color','none','FontSize',10);
ylabel("Relative measurement error",'FontSize',10)

%% detecton depth of  532 486 nm with different error
ax(2)=ax(2);hold on;
thrs = [0.1:0.01:1];
snr_thrs = 1./thrs;
for i=1:length(lambdas)
    color = fun_s2c(lambdas(i));
    if lambdas(i)==490 
        color = [1,0,0];
    end
    for j = 1:length(thrs)
        snr_thr = snr_thrs(j);
        [~,ind]=min(abs(SNRd(:,:,i)-snr_thr));
        max_depth_d(i,j) =z(ind);
        [~,ind]=min(abs(SNRn(:,:,i)-snr_thr));
        max_depth_n(i,j) =z(ind);
    end
    pt3(i)=plot(ax(2),thrs,max_depth_d(i,:),'-','color',color,'linewidth',1.2);hold(ax(2),'on')
%      pt4(i)=plot(ax(2),thrs,max_depth_n(i,:),'--','color',color,'linewidth',1.2);
end
xlabel(ax(2),"Relative measurement error");
ax(2).XTick = [0.3, 0.5, 0.7,1];
ax(2).XTickLabel={"30%","50%","70%","100%"};
ylabel(ax(2),"The maximum detectable depth (m)",'FontSize',10)
lg2 = legend(ax(2),[pt3],  {"440nm","490 nm","530 nm"});
    set(lg2,'edgecolor','none','Color','none','Location','northwest','FontSize',10);
xlabel(ax(2),"Relative measurement error",'FontSize',10)
set(ax(2),'XMinorGrid','on','XMinorTick','on','YMinorGrid','on','YMinorTick','on','box','off');
text(ax(2),0.03,58.5,'(b)')
set([ax(2).XLabel ax(2).YLabel ax(1).XLabel ax(1).YLabel ax(3).XLabel ax(3).YLabel],'FontSize',12);
print('-f1','-djpeg','-r600','F3')


