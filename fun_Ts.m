function [Ts] = fun_Ts(W,theta)
% FUN_TS calculate sea surface transmittance
% USAGE:
%   [Ts] = fun_Ts(W,theta)
% INPUTS:
%   W: sea surface wind speed
%   theta: incident angle
% OUTPUTS:
%   Ts: sea surface transmission
% EXAMPLE:
%    
% HISTORY:
%    2021-05-22: first edition by OLIDAR
% .. Authors: - 

sigma2 = 0.003+0.00512*W;
mu_i = cos(theta);
phi_i=0;
u = @(mu_t,phi_t)(scalar_btaw(sigma2,mu_i,phi_i,mu_t,phi_t).*abs(mu_t));
Ts = integral2(u,-1,0,0,2*pi)/pi;

end
function bt = scalar_btaw(sigma2,mu_i,phi_i,mu_t,phi_t)
% 大气入射光透射矩阵
% sigma2：由风速确定的海表坡度
% mu_i：入射天顶角cos值，在大气入射情况下，入射天顶角>90°，所以，-1<mu_i<0
% phi_i：入射光方位角，取0
% mu_t：透射光天顶角，-1<mu_t<0;
% phi_t：透射光方位角

% 确保mu_i,mu_r满足条件
mu_i = -abs(mu_i);
mu_t = -abs(mu_t);

% 求透射
cn1=1;cn2=1.333;
mu = -mu_t; mu_ = -mu_i;
sint_ = sqrt(1-mu.^2);sini_ = sqrt(1-mu_.^2);

cosTHETA = mu.*mu_+sini_.*sint_.*cos(phi_t-phi_i);
C = sqrt(cn2.^2+1-2.*cn2.*cosTHETA);
% cosi = (cn2.*cosTHETA-1)./C
cosi = (cn2.*cosTHETA-1)./C;
cost = (cn2-cosTHETA)./C;
thetai = real(acos(cosi));
mu_n = -(mu_-cn2*mu)./C;

t = TFAW(thetai);
t(cosi<0)=0; % cosi小于0,theta_i>180°,不可能，设为0
s = SHADOW(mu,mu_,sigma2);
g = (cn2.^2.*cost.*cosi)./(cn2.*cost-cn1.*cosi).^2;
gT = PROB(mu_n,sigma2)./(abs(mu).*mu_n);
bt = s.*pi.*t.*gT.*g./(abs(mu_));
%bt = pi.*t.*gT.*g./(abs(mu_));
%bt = SHADOW(mu,mu_,sigma2).*pi.*PROB(mu_n,sigma2)./(abs(mu).*mu_n.*abs(mu_)).*t.*g;


end

% s = shadow(mu,mu_,sigma2)  %abs(mu),abs(mu_)
function s = SHADOW(mu,mu_,sigma2)
s = 1./(1+A(abs(mu),sigma2)+A(abs(mu_),sigma2));
end
function a = A(mu,sigma2)
eta = mu./(sqrt(sigma2).*sqrt(1-mu.^2));
a = 0.5*(1./(sqrt(pi).*eta).*exp(-eta.^2)-erfc(eta));
end

% p = PROB(mu_n,sigma2)
function p = PROB(mu_n,sigma2)
p = 1./(pi.*sigma2.*mu_n.^3).*exp(-(1-mu_n.^2)./(sigma2.*mu_n.^2));
end

function TF=TFAW(theta)
m=1.333;
c1 = m.^2*cos(theta);c2=sqrt(m^2-sin(theta).^2);
rl = (c1-c2)./(c1+c2);
c1 = cos(theta);c2=sqrt(m^2-sin(theta).^2);
rr = (c1-c2)./(c1+c2);

tl = 1./m.*(1+rl);tr = 1+rr;
t=0.5.*(tl.^2+tr.^2);
c = m.*sqrt(1-(sin(theta)./m).^2)./cos(theta);
TF = c.*t;

end

