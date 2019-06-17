%find extraction of parent grid 
if ~exist('DOMNAM')
DOMNAM='GCOMS1k_LME_12_BLZE';
%DOMNAM='EA31FES';
end
%thredds=1;
%parent_UV=0;

domain_grid


ss=size(gdept);
nx=ss(1);ny=ss(2);nz=ss(3);
%date='20130224d05';
%date='20130130d05';
%date='20130828d05';
%date='19950105d05';
%Year='1996';
%fname_parent='ORCA0083-N06_1958m01T.nc';
fname_parent=['ORCA0083-N06_' date 'T.nc'];
fname_parentU=['ORCA0083-N06_' date 'U.nc'];
fname_parentV=['ORCA0083-N06_' date 'V.nc'];
name_parent=[parent_path fname_parent];
name_parent='/projectsa/NEMO/gmaya/ORCA12/mesh_hgr.nc';
lon_parent=double(ncread(name_parent,'nav_lon'));
lat_parent=double(ncread(name_parent,'nav_lat'));
if ~thredds
name_parent=[parent_path '/' Year '/' fname_parent];
name_parentU=[parent_path '/' Year '/' fname_parentU];
name_parentV=[parent_path '/' Year '/' fname_parentV];
else
%parent_dataset='http://opendap4gws.jasmin.ac.uk/thredds/nemo/dodsC/nemo_clim_agg/ORCA0083-N06_grid_';
parent_datasetT=['http://opendap4gws.jasmin.ac.uk/thredds/nemo/dodsC/grid_T/' Year '/ORCA0083-N06_' date]
parent_datasetU=['http://opendap4gws.jasmin.ac.uk/thredds/nemo/dodsC/grid_U/' Year '/ORCA0083-N06_' date]
parent_datasetV=['http://opendap4gws.jasmin.ac.uk/thredds/nemo/dodsC/grid_V/' Year '/ORCA0083-N06_' date]
%name_parent=[parent_dataset 'T_' Year];
%name_parentU=[parent_dataset 'U_' Year];
%name_parentV=[parent_dataset 'V_' Year];
name_parent=[parent_datasetT 'T.nc'];
name_parentU=[parent_datasetU 'U.nc'];
name_parentV=[parent_datasetV 'V.nc'];
end


%sss=double(ncread(name_parent,'sss'));

clear xx yy
xx(1)=x_min; yy(1)=y_min;
xx(2)=x_min; yy(2)=y_max;
xx(3)=x_max; yy(3)=y_max;
xx(4)=x_max; yy(4)=y_min;

[JJ II]=nn_search(lon_parent,lat_parent,xx,yy);

I1=min(II(:));
I2=max(II(:));
J1=min(JJ(:));
J2=max(JJ(:));
%%
if(0)
sss(sss>50)=NaN;
i=I1:I2;
j=J1:J2;
pcolor(lon_parent(i,j),lat_parent(i,j),sss(i,j));shading flat
hold on;
pcolor(lon_dom,lat_dom,D_dom);;shading flat
hold off
end
%% Produce Extract file
if(0)
I1m1=num2str(I1-1);
I2m1=num2str(I2-1);
J1m1=num2str(J1-1);
J2m1=num2str(J2-1);
out_nam=[domain_path  '/' DOMNAM '/' DOMNAM '_' fname_parent ];
VV=['! ncks -d x,' I1m1 ',' I2m1 ' -d y,' J1m1 ',' J2m1 ' '  name_parent ' ' out_nam ];
eval(VV);
end
%% Extract parent data
i=I1:I2;
j=J1:J2;
lon_prntex=lon_parent(i,j);
lat_prntex=lat_parent(i,j);
gdept_prntex=double(ncread(name_parent,'deptht'));
nzp=length(gdept_prntex);
if str2num(Year)<2013
tmpvname='potemp';
salvname='salin';
else
tmpvname='thetao';
salvname='so';
end
Uvname='uo';
Vvname='vo';

start=[I1 J1 1 1];
count=[length(i) length(j) nzp 1];
votemper=double(ncread(name_parent,tmpvname,start,count));
vosaline=double(ncread(name_parent,salvname,start,count));

vosaline(vosaline>50 | isnan(vosaline))=0;

votemper(votemper>50 | isnan(votemper))=0;

if parent_UV
    
u_parent=double(ncread(name_parentU,Uvname,start,count));
v_parent=double(ncread(name_parentV,Vvname,start,count));
u_parent(u_parent>50 | isnan(u_parent))=NaN;
v_parent(v_parent>50 | isnan(v_parent))=NaN;

end

ss=size(votemper);
nxp=ss(1);nyp=ss(2);

mbot_prntex=zeros(nxp,nyp);
for i=1:nxp;
    for j=1:nyp;
     if vosaline(i,j,1) ~=0 & isfinite(vosaline(i,j,1) )
    mbot_prntex(i,j)=find(vosaline(i,j,:)>0,1,'last');
    end
    end
end


