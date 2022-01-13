DOMNAM='LBay180';
environment

bathy_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_bathy_meter.nc'];
coords_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_coordinates.nc'];
mouth_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_rivermouths.txt'];
rivers_path='/work/jholt/Git/DEV_jholt/Global_Rivers/GlobalNEWS2ModeledExports_RH2000-version1.0.1/';
month_rivs_path='/work/jholt/Git/DEV_jholt/Global_Rivers/news_monthly_output/discharge/';

%%
% Grid information
Re=6367456.0*pi/180;
lon = double(ncread(coords_fname,'nav_lon'));
lat = double(ncread(coords_fname,'nav_lat'));
e1t = ncread(coords_fname,'e1t');
e2t = ncread(coords_fname,'e2t');
nx=size(lon,1);
ny=size(lon,2);
D = ncread(bathy_fname,'Bathymetry');
dr=mean([e1t(:) ; e2t(:)]);
dx=mean(e1t(:))./(Re.*cos(mean(lon(:)).*180/pi));
dy=mean(e2t(:))./Re;

fid=fopen(mouth_fname);
rn=fgets(fid);
rf=fgets(fid);
%while(~isempty(deblank(rn)));
i=0
 while rn ~=-1
     i=i+1
     disp(rn)
   a=strfind(rf,' ')  
i_r(i)=str2num(rf((a(2)+1):a(3)-1));
j_r(i)=str2num(rf((a(3)+1):a(4)-1));
river_data(i,4)=str2num(rf((a(4)+1):end));
 rn=fgets(fid);
 rf=fgets(fid);
 end  

 make_riverforcing
     
