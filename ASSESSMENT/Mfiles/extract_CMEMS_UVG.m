data_path='/projectsa/NEMO/data_obs/CMESM_UVG/';
daynum=[31 28 31 30 31 30 31 31 30 31 30 31];
fname=[ data_path 'dt_global_allsat_phy_l4_19950101_20190101.nc'];
lon=ncread(fname,'longitude');
lat=ncread(fname,'latitude');

[lon_uvg , lat_uvg]=meshgrid(lon,lat);
lon_uvg=lon_uvg'; lat_uvg=lat_uvg';
lon_uvg(lon_uvg>180)=lon_uvg(lon_uvg>180)-360;
lon(lon>180)=lon(lon>180)-360;
clear xx yy
xx(1)=x_min; yy(1)=y_min;
xx(2)=x_min; yy(2)=y_max;
xx(3)=x_max; yy(3)=y_max;
xx(4)=x_max; yy(4)=y_min;
%[JJ II]=nn_search(lon_uvg,lat_uvg,xx,yy);
%I1=min(II(:));
%I2=max(II(:));
%J1=min(JJ(:));
%J2=max(JJ(:));
I1=findnear(lon,x_min)-1;
I2=findnear(lon,x_max)-1;
J1=findnear(lat,y_min)-1;
J2=findnear(lat,y_max)-1;


i=I1:I2;
j=J1:J2;
lon_uvgex=lon_uvg(i,j);
lat_uvgex=lat_uvg(i,j);
start=[I1 J1 1 ];
count=[length(i) length(j),1];
nxg=length(i);
nyg=length(j);
years=1995:1995;
nyears=length(years);
ugosm=zeros(nxg,nyg,12*nyears);
vgosm=zeros(nxg,nyg,12*nyears);
ic=0;
for iy=years
    year=num2str(iy);
    for im=1:12;
        ic=ic+1;
        mnth=num2str(im);
        if im<10; mnth=['0' mnth];end
        nday=daynum(im);
        for iday=1:nday;
            day=num2str(iday);
             if iday<10; day=['0' day];end  
fname=[ data_path 'dt_global_allsat_phy_l4_' year  mnth day '_20190101.nc'];
try
ugos=ncread(fname,'ugos',start,count);
vgos=ncread(fname,'vgos',start,count);
disp(fname)
catch
disp('missing:')
disp(fname)
end
ugosm(:,:,ic)=ugosm(:,:,ic)+ugos/nday;
vgosm(:,:,ic)=vgosm(:,:,ic)+vgos/nday;
        end
    end
end



UVG_name=[assess_path DOMNAM '/UVg_mnth_' DOMNAM '_UVG.mat'];
save(UVG_name, 'ugosm','vgosm','lon_uvgex','lat_uvgex');
