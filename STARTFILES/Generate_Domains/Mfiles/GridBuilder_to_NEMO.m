grid_path=[projects_path '/Grid_files/'];
grid_name='';
flipit=1;
%DOMNAM='GCOMS1k_LME_12_BLZE';
grid_name=[DOMNAM '_Grid.mat'];

land_value=0;
load([grid_path grid_name]);
nx=SG.grid.m-1;
ny=SG.grid.n-1;
x=SG.grid.x;
y=SG.grid.y;
mask=SG.mask;
D=SG.depths;
if flipit
D=flipud(fliplr(D));
x=flipud(fliplr(x));
y=flipud(fliplr(y));
mask=flipud(fliplr(mask));
end
%must set to land value before finding single sea area
D(D<land_value)=0;
mask(D==0)=0;
if(0)
i=1:120;ip1=1:121;
D=D(i,:);
x=x(ip1,:);
y=y(ip1,:);
mask=mask(i,:);
end
%%
nx=size(D,1);
ny=size(D,2);

%floodfill to find single area
[mm]=numbarea(mask,1);
mask(mm>1)=0;
D(mask==0)=0;
%%


if ~exist ([domain_path  '/' DOMNAM '/']);
  eval( [' mkdir   ' [domain_path  '/' DOMNAM '/'] ])
end
bathy_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_bathy_meter.nc'];
coords_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_coordinates.nc'];

Re=6367456.0*pi/180;
grd = {'t','u','v','f'} ;
coord_var = {'e1','e2','glam','gphi'} ;
for g = 1:length(grd)    
    for v = 1:length(coord_var)
   eval([coord_var{v} grd{g} '=zeros(nx,ny);']);     
    end
end
for i=1:nx;
for j=1:ny; 
dxv2=((y(i+1,j+1)-y(i+1,j)).*Re).^2 ...
    + ((x(i+1,j+1)-x(i+1,j)).*Re*cos(0.5*(y(i+1,j+1)+y(i+1,j))*pi/180)).^2;
e1v(i,j)=sqrt(dxv2);

dyu2=((y(i+1,j+1)-y(i,j+1)).*Re).^2 ...
    + ((x(i+1,j+1)-x(i,j+1)).*Re*cos(0.5*(y(i+1,j+1)+y(i,j+1))*pi/180)).^2;
e2u(i,j)=sqrt(dyu2);

end
end

for i=1:nx;
for j=2:ny; 
e1t(i,j)=0.5*(e1v(i,j)+e1v(i,j-1));
end
end
for i=2:nx;
for j=1:ny; 
e2t(i,j)=0.5*(e2u(i,j)+e2u(i-1,j));
end
end
e1t(1,:)=e1v(1,:);e2t(1,:)=e2u(1,:);
e1t(:,1)=e1v(:,1);e2t(:,1)=e2u(:,1);

for i=1:nx-1;
for j=1:ny; 
e1u(i,j)=0.5*(e1t(i,j)+e1t(i+1,j));
end
end
for i=1:nx;
for j=1:ny-1; 
e2v(i,j)=0.5*(e2t(i,j)+e2t(i,j+1));
end
end
e1u(nx,:)=e1t(nx,:);
e2v(:,ny)=e2t(:,ny);

for i=1:nx-1;
for j=1:ny-1; 
e1f(i,j)=0.25*(e1u(i,j)+e1u(i,j+1)+e1v(i,j)+e1v(i+1,j));
e2f(i,j)=0.25*(e2u(i,j)+e2u(i,j+1)+e2v(i,j)+e2v(i+1,j));
end
end
e1f(:,ny)=0.5*(e1u(i,j)+e1v(i,j));
e2f(nx,:)=0.5*(e2u(i,j)+e2v(i,j));

%%%%

for i=1:nx;
    for j=1:ny
glamt(i,j)=0.25*(x(i,j)+x(i+1,j)+x(i,j+1)+x(i+1,j+1));
gphit(i,j)=0.25*(y(i,j)+y(i+1,j)+y(i,j+1)+y(i+1,j+1));
glamu(i,j)=0.5*(x(i+1,j+1)+x(i+1,j));
gphiu(i,j)=0.5*(y(i+1,j+1)+y(i+1,j));
glamv(i,j)=0.5*(x(i+1,j+1)+x(i,j+1));
gphiv(i,j)=0.5*(y(i+1,j+1)+y(i,j+1));

glamf(i,j)=x(i+1,j+1);
gphif(i,j)=y(i+1,j+1);

    end
end

%e1t e2t
%e1u e2u
%e1v e2v
%e1f e2f
%glamt gphit
%glamu  gphiu
%glamv  gphiv
%glamf  gphif
%%
DD=D;
DD(D==0)=NaN;
figure
pcolor(glamt,gphit,DD);shading flat;colorbar
title([DOMNAM ' : Bathymetry']);

%%
make_nemo_V34_coords
xmin=nanmin(glamt(:));
xmax=nanmax(glamt(:));
ymin=nanmin(gphit(:));
ymax=nanmax(gphit(:));

DOMSTR=[ DOMNAM '; xmin=' num2str(xmin,3) '; xmax=' num2str(xmax,3)  '; ymin=' num2str(ymin,3) '; ymax=' num2str(xmax,3)]

eval(['!echo "' DOMSTR '" >> ' [ domain_path 'Domain_list' ]  ])




 
