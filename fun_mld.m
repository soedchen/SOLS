function fun_mld(month)
% 生成各月MLD
% 不同月份的探测深度
file02 = 'L3m_20180201-20180228__GLOB_25_AVW-MODVIR_CHL1_MO_00';
file05 = 'L3m_20180501-20180531__GLOB_25_AVW-MODVIR_CHL1_MO_00';
file08 = 'L3m_20180801-20180831__GLOB_25_GSM-MODVIR_CHL1_MO_00';
file11 = 'L3m_20181101-20181130__GLOB_25_AVW-MODVIR_CHL1_MO_00';
% 
file = sprintf('file%02d',month);
file1 = eval(file);
% month = 2;
% name = 'month2';
ext = '.nc';
file = [file1 ext];
% 叶绿素浓度
% file_info = ncinfo(file);
chl = ncread(file,"CHL1_mean");
lon = ncread(file,"lon");
lat = ncread(file,"lat");
fun_plotGlobe(lon,lat,log10(chl),"chl",true);
[LAT,LON]=meshgrid(lat,lon);

% MLD 
file_mld = "mld_DT02_c1m_reg2.0.nc";
%file_mld_info.Variables.Name;
lat_mld = ncread(file_mld,"lat");
lon_mld = ncread(file_mld,"lon");
lon_mld(lon_mld>180) = lon_mld(lon_mld>180) - 360;
ind = find(lon_mld<0,1);
num = length(lon_mld);
lon_mld = lon_mld([ind:num,1:ind-1]);
lon_mld = [-180;lon_mld];
[LAT_mld,LON_mld]=meshgrid(lat_mld,lon_mld);

mld = ncread(file_mld,"mld");
mld = mld(:,:,month);
mld(mld==-9999)=NaN; % 缺失值
mld(mld == 1e9)=NaN; % Mask 陆地
mld = mld([ind:num,1:ind-1],:);
mld = [mld(end,:); mld];
mld_int = interp2(LAT_mld,LON_mld,mld,LAT,LON);

% 激光雷达基本参数
lambdas = 490;
O=1;To = 0.9;Ts = 0.95;H = 400E3;delta_t = 7.2E-9;n = 1.33;
E0 = 1.3;B = 200E6;D = 1.5;A = pi.*(D/2).^2;
FOV = 0.15E-3; delta_lambda = 0.1;
R = 0.45;F = 4;M = 100;Id = 1.31e-12;
e = 1.602e-19;h = 6.626E-34;v =  2.99793e8;
theta = 0;theta_w = 0;
Z = 300;Lb=1.4;
m =1;
thr = 1/1;
params = [O,To,Ts,H,E0, ... 
    B,D,A,FOV,delta_lambda, ... 
    n,R,F,Id,delta_t, ... 
    v,Lb,theta,theta_w,Z,m,thr,M];
[row,col] = size(chl);
chls = reshape(chl,[],100);  % 25 50 100 600 800
[Zmax_ns,Zmax_snrd,Zmax_snrn,l_ns_100,l_snrd_100,l_snrn_100] = fun_Zmax(lambdas,chls,params);
% 设置NaN
Zmax_ns(Zmax_ns==0)=NaN;
Zmax_snrd(Zmax_snrd==0)=NaN;
Zmax_snrn(Zmax_snrn==0)=NaN;
% 重排列
chls = reshape(chls,row,col);
Zmax_ns = reshape(Zmax_ns,row,col);
Zmax_snrd = reshape(Zmax_snrd,row,col);
Zmax_snrn = reshape(Zmax_snrn,row,col);

% 差值
diff_ns = Zmax_ns - mld_int;
diff_snrd = Zmax_snrd - mld_int;
diff_snrn = Zmax_snrn - mld_int;



% plotGlobe_fun2(lon,lat,diff_sbr,'Zmax\_sbr  (m)',true);print ('-f1', '-djpeg', '-r600', "diff_sbr_2月")

sat1 = tabulate(diff_snrd(:));
%bar(sat1(:,1),sat1(:,3))
h = histogram(sat1(:,1),100,'Normalization','probability');
%xlim([-150 150])

binedges = h.BinEdges;
bf = binedges(1:end-1);
bl = binedges(2:end);
bin = (bf+bl)/2;
values = h.Values;
hold off;
save(['data_mld' num2str(month)])

% https://blog.csdn.net/jd13514611076/article/details/101621211
f2 = figure;
ha = tight_subplot(2,2,0.04);
set(f2,'Position',[429.8889  186.3333  889.3333  674.6667]);
axes(ha(1));[mp(1),co(1)]=fun_plotGlobe(lon,lat,Zmax_snrd,'Zmax_snrd',true);
    hold on;text(-3.45,1.5,'(a)');text(-3.05,-2.605,'m');caxis(ha(1),[0 120]);
axes(ha(2));[mp(2),co(2)]=fun_plotGlobe(lon,lat,diff_snrd,'diff_snrd',true);
    hold on;text(-3.45,1.5,'(b)');text(-2.9,-2.605,'m');caxis([-150 150]);
axes(ha(3));[mp(3),co(3)]=fun_plotGlobe(lon,lat,mld_int,'mld_int',true);
    hold on;text(-3.45,1.5,'(c)');text(-3.05,-2.605,'m');caxis(ha(3), [0 max(max(max(mld_int)))]);
colormap(ha(2),m_colmap('diverging','step',10));
ax1=ha(4);pos = get(ax1,'Position');
    set(ax1,'XColor','k','YColor','k','YAxisLocation','left','Position',pst - [-0.04 -0.09 0.105 0.10]);
    ax2=axes('Position',get(ax1,'Position'),...
    'YAxisLocation','right',...
    'Color','none','YColor','r');
pt(1) = plot(bin,values,'k','Parent',ax1,'LineWidth',1.2);
xlim(ax1,[-200 100]);text(-255,1,'(c)')
ylabel(ax1,'Relative frequency');
xlabel(ax1,'Difference (m)');
set(ax1,'Box','off')        % 关闭ax1在右侧坐标轴的刻度
% 累计频率
temp = fliplr(values);
cs = cumsum(temp);  % 累计pinlv
cs = fliplr(cs);
hold on 
plot(bin,cs,'r','Parent',ax2,'LineWidth',1.2);
cs_0 = interp1(bin,cs,0);
pt(2) = plot([0 0 160],[0 cs_0 cs_0],'--','LineWidth',1.2);
xlim([-200 100])
ylabel("Cumlative relative frequency")
print ('-f2', '-djpeg', '-r600', ['mld-' num2str(month) '-frequency'])
