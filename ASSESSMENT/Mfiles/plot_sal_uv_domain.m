addpath('/work/jholt/Git/GCOMS1k/STARTFILES/Generate_Domains/Mfiles/');
addpath('/work/jholt/Git/GCOMS1k/STARTFILES/Generate_Forcing/Mfiles/');
addpath('/login/jdha/matlab/new_matlab/models/nemo/utilities');
addpath('/login/jdha/matlab/new_matlab/models/nemo/general');
environment
DOMNAM='BLZE12';
EXPNUM='02';
RUNNAM='';
im=10;
iy=2015;
UV=1;
TS=1;
SSH=0;
domain_grid
read_field
sss=squeeze(soce(:,:,1,:));
ssu=squeeze(uoce(:,:,1,:));
ssv=squeeze(voce(:,:,1,:));
nx=size(sss,1);
ny=size(sss,2);
x=lon_dom;
y=lat_dom;
it=1:1;
%it=240:272;
% pick time steps to average
%select sub-region
i0=1;
i1=nx;
j0=1;
j1=ny;

%i0=20;
%i1=105;
%j0=280
%j1=460;

%%
%plot every np vectory arrow
np=8
%np=2;

%scale arrows
%Sc=0.012
Sc=0.003;

salrange=[26 34.5]
salrange=[30 36]
xu_sc=(x(1,end)+x(1,1))/2;
yu_sc=(y(1,end)+y(1,1))/2;
Uscale=1;
figure(2)
grid_file=[domain_path  '/' DOMNAM '/' DOMNAM '_domain_cfg.nc'];
[gcos,gsin] = nemo_grid_angle_hacked(grid_file,2:nx,2:ny);
plot_sal_uv

colorbar
title(['1d mean currents and salinity BLZE12 1 Oct 2015 np=8 run02'])
