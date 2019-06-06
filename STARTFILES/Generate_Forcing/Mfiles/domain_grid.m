domcfg_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_domain_cfg.nc'];
bathy_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_bathy_meter.nc'];
lon_dom=double(ncread([domcfg_fname],'nav_lon'));
lat_dom=double(ncread([domcfg_fname],'nav_lat'));
dx_dom=double(ncread([domcfg_fname],'e1t'));
dy_dom=double(ncread([domcfg_fname],'e2t'));

D_dom=double(ncread([bathy_fname],'Bathymetry'));
mbot=double(ncread([domcfg_fname],'bottom_level'));
mask=double(ncread([domcfg_fname],'top_level'));
gdept=double(ncread([domcfg_fname],'gdept_0'));
[nx ny]=size(D_dom)
%find box
x_min=min(lon_dom(:));
y_min=min(lat_dom(:));

x_max=max(lon_dom(:));
y_max=max(lat_dom(:));
