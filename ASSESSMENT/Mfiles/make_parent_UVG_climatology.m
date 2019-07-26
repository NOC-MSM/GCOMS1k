% Make monthly means of model data

addpath('~/work/Git/GCOMS1k/STARTFILES/Generate_Forcing/Mfiles')
addpath('~/work/Git/GCOMS1k/STARTFILES/Generate_Domains/Mfiles')
environment
UV=0;
TS=0;
SSH=1;
if ~exist('DOMNAM')
DOMNAM='BLZE12';
EXPNUM='01';
RUNNAM='';
end

domain_grid

%% Define parent grid

parent_path='/work/jholt/JASMIN/NEMO-ORCA0083-N006/';

outname=['/projectsa/accord/GCOMS1k/DATA_SOURCES/ORCA0083/mesh_hgr.nc'];
lon_parent=double(ncread(outname,'nav_lon'));
lat_parent=double(ncread(outname,'nav_lat'));
dx=double(ncread(outname,'e1u'));
dy=double(ncread(outname,'e2v'));
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
i=I1:I2;
j=J1:J2;
ii=i;
jj=j;
lon_prntex=lon_parent(i,j);
lat_prntex=lat_parent(i,j);
dx_prntex=dx(i,j);
dy_prntex=dy(i,j);
fcor=1.458423d-4*sin(pi/180.*lat_prntex);

[nx_p ny_p]=size(lon_prntex);

%%

ll(3)=1;
ll(1)=1;

im=1:12;
yearstart=1995;
yearstop=2006;
nyear = yearstop-yearstart+1;

nc=12*nyear
Ugm=zeros(nx_p,ny_p,nc);
Vgm=zeros(nx_p,ny_p,nc);
ic=0;
for iy=yearstart:yearstop;
    disp(iy)

for im=1:12
    disp(im)
ic=ic+1;
i=ii;j=jj;
read_field_parent
    sshm=ssh;
    i=1:nx_p-1;
    j=1:ny_p-1;
    Ug=ones(nx_p,ny_p)*NaN;
    Vg=ones(nx_p,ny_p)*NaN;
    Vg(i,:)=g.*(sshm(i+1,:)-sshm(i,:))./(dx_prntex(i,:).*fcor(i,:));
    Ug(:,j)=-g.*(sshm(:,j+1)-sshm(:,j))./(dy_prntex(:,j).*fcor(:,j));
    
    Ugm(:,:,ic)=Ugm(:,:,ic)+Ug;
    Vgm(:,:,ic)=Vgm(:,:,ic)+Vg;
    
 
end
end




%%%
nemo_name=[assess_path DOMNAM '/UVg_mnth_' DOMNAM '_ORCA0083.mat'];
save(nemo_name, 'Ugm','Vgm','lon_prntex','lat_prntex');



