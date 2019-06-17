%set up environment
environment
DOMNAM='GTHI35';
addpath(genpath('/login/jdha/matlab/new_matlab/utilities/ann_mwrapper'))
%Extract pararent grid and T & S data
Year='1995';
date='19950105d05';
thredds=0;
parentUV=0;
%extract_orca0083
%% Flood fill land

n_it=5; %number of iterations;

%save mask
mbot_pr=zeros(nxp,nyp);
for i=1:nxp
    for j=1:nyp;
    if vosaline(i,j,1)>0        
    mbot_pr(i,j)=find(vosaline(i,j,:)>0,1,'last');    
    end
    end
end

%%
vosaline0=vosaline; %this is not used
votemper0=votemper;
%%
vosaline1=vosaline;
votemper1=votemper;
for i_it=1:n_it %number of cells to flood 
ir=2:nxp-1;
jr=2:nyp-1;
for k=1:nzp;   
[I J] = find(vosaline(ir,jr,k)==0 & (vosaline(ir+1,jr,k) ~= 0 | vosaline(ir-1,jr,k) ~= 0 + ...
                                   vosaline(ir,jr+1,k) ~= 0 | vosaline(ir,jr-1,k) ~= 0) );
I=I+1;
J=J+1;
II=I+(J-1)*nx; 

for ii=1:length(I);
i=I(ii);j=J(ii);

norm=(double(vosaline(i+1,j,k)~=0) + double(vosaline(i-1,j,k)~=0) + double(vosaline(i,j+1,k)~=0) + double(vosaline(i,j-1,k)~=0));
vosaline1(i,j,k)= vosaline(i+1,j,k) + vosaline(i-1,j,k) + vosaline(i,j+1,k) + vosaline(i,j-1,k);
votemper1(i,j,k)= votemper(i+1,j,k) + votemper(i-1,j,k) + votemper(i,j+1,k) + votemper(i,j-1,k);
vosaline1(i,j,k)= vosaline1(i,j,k)/norm;
votemper1(i,j,k)= votemper1(i,j,k)/norm;

end
end
vosaline=vosaline1;
votemper=votemper1;
end

votemper(vosaline==0)=NaN;
vosaline(vosaline==0)=NaN;

%% Horizontal interpolation
tmp_dom_pz=zeros(nx,ny,nzp);
sal_dom_pz=zeros(nx,ny,nzp);

for iw=1:4;
V{iw}=zeros(nx,ny,nzp);
W{iw}=zeros(nx,ny,nzp);
end
%find nearest neighbours
[JJ II]=nn_search(lon_prntex,lat_prntex,lon_dom(:),lat_dom(:));
% weights
for iw=1:4;
for j=1:ny;
for i=1:nx;
ii=i+(j-1)*nx;
rx=(lon_prntex(II(iw,ii),JJ(iw,ii))-lon_dom(i,j))*Re*cos(pi/180*lat_dom(i,j));
ry=(lat_prntex(II(iw,ii),JJ(iw,ii))-lat_dom(i,j))*Re;
rr=sqrt(rx.^2+ry.^2)+tiny;
W{iw}(i,j,:)=1./rr; %distance weighted mean    
end
end
end
%normalise
Wtmp=W;
for iw=1:4
W{iw}=Wtmp{iw}./(Wtmp{1}+Wtmp{2}+Wtmp{3}+Wtmp{4});
end


for j=1:ny;
for i=1:nx;
ii=i+(j-1)*nx;
mbot_pz(i,j)= max([mbot_prntex(II(1,ii),JJ(1,ii)) ...
     mbot_prntex(II(2,ii),JJ(2,ii))...
     mbot_prntex(II(3,ii),JJ(3,ii))...
     mbot_prntex(II(4,ii),JJ(3,ii))]);

end
end



%% temprature
for iw=1:4
for j=1:ny;
for i=1:nx;
ii=i+(j-1)*nx;
V{iw}(i,j,:)=votemper(II(iw,ii),JJ(iw,ii),:);
end
end
end
for iw=1:4;
V{iw}( ~isfinite(V{iw}))=0;
    W{iw}( ~isfinite(V{iw}))=0;
end
%normalise
Wtmp=W;
for iw=1:4
W{iw}=Wtmp{iw}./(Wtmp{1}+Wtmp{2}+Wtmp{3}+Wtmp{4});
end

for iw=1:4
tmp_dom_pz=tmp_dom_pz+V{iw}.*W{iw};
end
%% salinity
for iw=1:4
for j=1:ny;
for i=1:nx;
ii=i+(j-1)*nx;
V{iw}(i,j,:)=vosaline(II(iw,ii),JJ(iw,ii),:); %parent data a 4 nearest points
end
end
end

for iw=1:4

    V{iw}( ~isfinite(V{iw}))=0;
    W{iw}( ~isfinite(V{iw}))=0;
end
    
%normalise
Wtmp=W;
for iw=1:4
W{iw}=Wtmp{iw}./(Wtmp{1}+Wtmp{2}+Wtmp{3}+Wtmp{4});
end
    
for iw=1:4   
sal_dom_pz=sal_dom_pz+V{iw}.*W{iw};
end

%% check statically stable - should use better EOS here
%rho=equstate(tmp_dom_pz,sal_dom_pz,9.81);
%drhodz=diff(rho,3);






%Vertical interpolation
tmp_dom=zeros(nx,ny,nz,1);
sal_dom=zeros(nx,ny,nz,1);
mask3d=zeros(nx,ny,nz,1);
for j=1:ny;
for i=1:nx;
if mask(i,j)~=0;

 k1=1:mbot(i,j);
mask3d(i,j,k1)=1;
 Z=gdept(i,j,k1);

  tmp_dom(i,j,k1,1)=interp1(gdept_prntex(:),squeeze(tmp_dom_pz(i,j,:)),Z);
  sal_dom(i,j,k1,1)=interp1(gdept_prntex(:),squeeze(sal_dom_pz(i,j,:)),Z);
 
 %fill surface
  kt=Z<gdept_prntex(1);
 if length(kt>0);
  tmp_dom(i,j,kt,1)=tmp_dom_pz(i,j,1);
  sal_dom(i,j,kt,1)=sal_dom_pz(i,j,1);
 end
 %fill bottom
if mbot_pz(i,j)>0
   kb=Z>gdept_prntex(mbot_pz(i,j));
 if length(kb>0);
     kbb=mbot_pz(i,j);
 tmp_dom(i,j,kb,1)=tmp_dom_pz(i,j,kbb);
 sal_dom(i,j,kb,1)=sal_dom_pz(i,j,kbb);
 end
end
 %%
 
 
end
end
end
%no gradient at boundary
%tmp_dom(1,:,:)=tmp_dom(2,:,:);
%tmp_dom(nx,:,:)=tmp_dom(nx-1,:,:);
%tmp_dom(:,1,:)=tmp_dom(:,2,:);
%tmp_dom(:,ny,:)=tmp_dom(:,ny-1,:);

%%remask;

tmp_dom(mask3d~=1)=0;
sal_dom(mask3d~=1)=0;

II=find(~isfinite(sal_dom));
if length(II)~=0;
 disp('Have NaN in Sea  '); 
 disp('Increase n_it and re-run; stopping')
 return
end

%Write IC file 
%%
if thredds;
    fname_parent=['ORCA0083-N06_' Year];
end
vnumber='v1';
out_nam=[domain_path  '/' DOMNAM '/' DOMNAM '_IC_' vnumber '_' fname_parent  '.nc';];
check_delete (out_nam);

nccreate(out_nam,'time_counter','Dimensions',{'time_counter',Inf},'Format','netcdf4_classic');
nccreate(out_nam,'lat','Dimensions',{'lat',ny},'Format','netcdf4_classic');
nccreate(out_nam,'lon','Dimensions',{'lon',nx},'Format','netcdf4_classic');
nccreate(out_nam,'gdep','Dimensions',{'gdep',nz},'Format','netcdf4_classic');
%nccreate(out_nam,'votemper','Dimensions',{'lon',nx,'lat',ny,'gdep',nz,'time_counter',1},'Format','netcdf4_classic');
%nccreate(out_nam,'vosaline','Dimensions',{'lon',nx,'lat',ny,'gdep',nz,'time_counter',1},'Format','netcdf4_classic');
nccreate(out_nam,'votemper','Dimensions',{'lon',nx,'lat',ny,'gdep',nz},'Format','netcdf4_classic');
nccreate(out_nam,'vosaline','Dimensions',{'lon',nx,'lat',ny,'gdep',nz},'Format','netcdf4_classic');

%ncwrite(out_nam,'lon',(1:nx));
%ncwrite(out_nam,'lat',(1:ny));
%ncwrite(out_nam,'gdep',(1:nz));
ncwrite(out_nam,'votemper',tmp_dom);
ncwrite(out_nam,'vosaline',sal_dom);

