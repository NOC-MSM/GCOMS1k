environment
DOMNAM='BLZE12';
coords_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_coordinates.nc'];
bathy_fname=[domain_path  '/' DOMNAM '/' DOMNAM '_bathy_meter.nc'];

D = ncread(bathy_fname,'Bathymetry');
[nx,ny]=size(D);
e1t = ncread(coords_fname,'e1t');
e2t = ncread(coords_fname,'e2t');
rivfilename=[domain_path  '/' DOMNAM '/' DOMNAM '_rivertest_v2.nc'];
rivfilename_out=[domain_path  '/' DOMNAM '/' DOMNAM '_rivertest_v2_M1.nc'];
rivfile_data=[domain_path  '/' DOMNAM '/RiverData/doublerunQ.mat'];
load(rivfile_data )

rho0=1000;
flw_in=ncread(rivfilename,'rorunoff');
flw_in1=flw_in(:,:,1).*e1t.*e2t/rho0;
flw_in1(D==0)=NaN;
pcolor(flw_in1');shading flat
drawnow
ok=0;
while ok==0
ipt=str2num(input('i point for river data : ','s'));
jpt=str2num(input('j point for river data : ','s'));
if ipt >= 1 &  ipt<=nx &  jpt >= 1 &  jpt<=ny
    ok=1;
end
if flw_in(ipt,jpt,1)==0
ok1=0;
while(ok1==0)
disp('No river input at this point. This will be an additional river.')
inp=input('Continue ? [y/n] ','s')
if inp=='y';ok1=1;end
if inp=='n';ok1=1;ok=0;end
end
end
end
%%
sc=e1t(ipt,jpt).*e2t(ipt,jpt)/rho0;;
flwp=squeeze(flw_in(ipt,jpt,:))*sc;

%makle month means;
flwm=zeros(1,12);
for im=1:12;
 i=find(mnt==im);
 flwm(im)=nanmean(flw(i));
end

%%
figure(2)
im=1:12;
plot(im,flwp,im,flwm)
xlabel('Month')
ylabel('Flow m^3/s')
legend('Global NEWS 2 + modulation','doublerunQ')
%%

flw_in(ipt,jpt,:)=flwm/sc;
check_delete( rivfilename_out)
eval(['!cp ' rivfilename ' ' rivfilename_out ]);
output=rivfilename_out;
ncwrite(output,'rorunoff',flw_in)
