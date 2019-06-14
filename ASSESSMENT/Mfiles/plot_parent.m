addpath('/work/jholt/Git/GCOMS1k/STARTFILES/Generate_Domains/Mfiles/');
addpath('/work/jholt/Git/GCOMS1k/STARTFILES/Generate_Forcing/Mfiles/');
environment
DOMNAM='EA31FES';
parent_UV=1;
thredds=1;
Year='2005';
date='20050105d05';
extract_orca0083;
ssu=squeeze(u_parent(:,:,1));
ssv=squeeze(v_parent(:,:,1));
sss=squeeze(vosaline(:,:,1));
nx=size(sss,1);
ny=size(sss,2);

it=1; % pick time steps to average
%select sub-region
i0=1;
i1=nx;
j0=1;
j1=ny;
disp(nx)
%plot every np vectory arrow
np=1;

%sclae arrows
Sc=0.003;


x=lon_prntex;
y=lat_prntex;
figure(1)
gcos=1;
gsin=0;
plot_sal_uv

hold on;

xa=[lon_dom(1,1) lon_dom(1,end) lon_dom(end,end) lon_dom(end,1) lon_dom(1,1)];
ya=[lat_dom(1,1) lat_dom(1,end) lat_dom(end,end) lat_dom(end,1) lat_dom(1,1)];

m_plot(xa,ya,'r')

hold off
colorbar
title('5d mean currents and salinity ORCA0083 30 Jan 2013')