function [mp,co] = fun_plotGlobe(lon,lat,data,titles,colorbar_status)
% 绘图
% load("05021258.mat")
% Rearrange data to lie in the longitude limits I give for the
% projection
% -180-180转为0-360
num = length(lon);
[~,i]=max(lon>=0);
ind = [i:num 1:i-1];
lon = lon(ind);
lon(lon<0) = lon(lon<0)+360;
lon_360 = lon;

data = data';
data = data(:,ind);
% 生成经纬网
[LG,LT]=meshgrid((lon_360)',lat');  % 经纬网坐标(0:360,-90:90)

[~,i]=max(lon_360>30);
num = length(lon_360);
ind = [i:num 1:i-1]; % [31:361 1:30]
data = data(:,ind);
LT=LT(:,ind);
LG=LG(:,ind);LG(LG>30)=LG(LG>30)-360; %...and subtract 360 to some longitudes

m_proj('robinson','lon',[-330 30]);
mp = m_pcolor(LG,LT,data);
% m_pcolor(LON,LAT,Zmax_ns)
% Lon = LON+180;
% m_pcolor(A,B,Zmax_ns')
% m_pcolor(Lon,LAT,Zmax_ns)
% m_coast('patch',[.7 .7 .7],'edgecolor','none');
m_grid('tickdir','out','linewi',1,'fontsize',8);
% This is a perceptually uniform jet-like color scale, but in m_colmap
% we can add some simple graduated steps to make the pcolor look a little
% more like a contourf
colormap(m_colmap('jet','step',10));
% title(h,'Z_m_a_x^N^s全球分布图','fontsize',14);
%title(h,titles,'fontsize',14,'fontname','Arial');

% 将colorbar 放在上面
% h=colorbar('northoutside');
% set(h,'pos',get(h,'pos')+[.2 .05 -.4 0],'tickdir','out')  

% 将colorbar放在下面
if colorbar_status
    co=colorbar('southoutside'); % 'north' | 'south' | 'east' | 'west' | 'northoutside'
    % 'pos', [横坐标，纵坐标，宽度，高度] 位置
    % 'ticks',刻度线位置
    set(co,'tickdir','in');
    % set('Fontsize',14)
    % 参加文字标识
    %co.Label.String = titles;
end
% pos = get(h,'pos');
% h.Label.Position = pos([1,2])+[0.2 -0.01];
% set(h,'pos',get(h,'pos')+[0.2 -0.00 -.4 0],'tickdir','out')

title(titles);
set(gcf,'color','w');

end