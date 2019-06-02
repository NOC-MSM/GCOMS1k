%
%iwant_LMEs=[32 34];
landheight=0;
lme_read


gebco_path=[projects_path '/DATA_SOURCES/GEBCO_2014/'];
gebco_name='GEBCO_2014_2D.nc';


ncname=[bathy_path 'LME_' nn 'GEBCO_bathy.nc'];
disp(['Bathymetry file: :' ncname]);
if exist(ncname)
    inp=input('Delete this file?: y/n [n]','s');
if inp=='y';
delete(ncname);
end
   end
xg=ncread([gebco_path gebco_name],'lon');
yg=ncread([gebco_path gebco_name],'lat');

i0=findnear(x0,xg);
i1=findnear(x1,xg);
j0=findnear(y0,yg);
j1=findnear(y1,yg);

start=[i0-1 j0-1];
count=[i1-i0+1 j1-j0+1];

D1=-(ncread([gebco_path gebco_name],'elevation',start,count));
lon=(ncread([gebco_path gebco_name],'lon',start(1),count(1)));
lat=(ncread([gebco_path gebco_name],'lat',start(2),count(2)));
nx=length(lon);
ny=length(lat);

nccreate(ncname,'elevation','Dimension',{'lon' nx,'lat' ny});
nccreate(ncname,'lon','Dimension',{'lon' nx});
nccreate(ncname,'lat','Dimension',{'lat' ny});
ncwrite(ncname,'elevation',D1);
ncwrite(ncname,'lon',lon);
ncwrite(ncname,'lat',lat);





