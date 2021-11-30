% Detection probability vs photo number
close all;clear;
addpath(genpath(pwd));
N = [1e-5:1e-5:1e-2 2e-2:1e-2:1e2];
P = fun_Prb(N);
subplot(121);
loglog(N,P,'b','LineWidth',1.2);hold on;
loglog([1e-5 0.01 0.01],[0.01 0.01 1e-5],'r');
xlabel('有效光子数');
ylabel('探测概率');
xlim([1e-5 10])
subplot(122);
semilogx(N,P,'b','LineWidth',1.2)
xlabel('有效光子数');
ylabel('探测概率');
% ax(1) = axes();
% loglog(N,P,'b','LineWidth',1.2);
% ax(2)=axes();
% plot(N,P,'r','LineWIdth',1.2);
% set(ax,'Color','none');
% set(ax(1),'Position',[0.13 0.11 0.3 0.8150]); % 左 下 右+ 上+
% set(ax(2),'Position',[0.43 0.11 0.52 0.8150]);
% set(ax(2),'YAxisLocation','right');
% xlim(ax(1),[1e-5 1e-1]);
% xlim(ax(2),[1e-1 1e2]);