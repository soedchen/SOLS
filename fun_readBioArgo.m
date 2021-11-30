function [z,chla,lat,lon,time,info]=fun_readBioArgo(filename)
c1=9.72659;
c2=-2.251e-5;
c3=2.279e-10;
c4=-1.82e-15;
r=2.18e-6;
info = ncinfo(filename);
lat = ncread(filename,'LATITUDE');
lat = mean(lat);
lon = ncread(filename,'LONGITUDE');
lon = mean(lon);
time = ncread(filename,'DATE_CREATION'); %
time = time';
lat_ = abs(lat*pi/180);
g=9.780318*(1+(5.2788e-3)*(1e-3)*(sin(lat_)).^2+(1e-5)*(sin(lat_)).^4);
pres=ncread(filename,'PRES');

chla_raw=ncread(filename,'CHLA_ADJUSTED');%数据读取 CHLA  ; CHLA_ADJUSTED
[~,n_profile] = size(chla_raw);
idx=1;
if n_profile==1
    idx = 1;
else
    nannum = sum(isnan(chla_raw));
    if nannum(2)>nannum(1)
        idx = 1;
    else
        idx=2;
    end
end
p = pres(:,idx);
chla = chla_raw(:,idx);
z=(c1*p+c2*(p).^2+c3*(p).^3+c4*(p).^4)./(g+0.5*r*p);
end