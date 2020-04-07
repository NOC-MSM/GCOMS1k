% Make monthly means of model data

addpath('~/work/Git/GCOMS1k/STARTFILES/Generate_Forcing/Mfiles')
addpath('~/work/Git/GCOMS1k/STARTFILES/Generate_Domains/Mfiles')
environment
UV=0;
if ~exist('DOMNAM')
DOMNAM='BLZE12';
EXPNUM='01';
RUNNAM='';
end

domain_grid

%% Define parent grid

parent_path='/work/jholt/JASMIN/NEMO-ORCA0083-N006/';

outname=[parent_path '/1995/ORCA0083-N06_1995m01T.nc'];
lon_parent=double(ncread(outname,'nav_lon'));
lat_parent=double(ncread(outname,'nav_lat'));

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

lon_prntex=lon_parent(i,j);
lat_prntex=lat_parent(i,j);
[nx_p ny_p]=size(lon_prntex);

%%

varname{1}='sst_m';
varname{2}='sbt';
varname{3}='sss_m';
varname{4}='sbs';
nemoname{1}='sst';
nemoname{3}='sss';
ll(3)=1;
ll(1)=1;

im=1:12;
yearstart=1995;
yearstop=1995;
nyear = yearstop-yearstart+1;
for iv=[1 3];
 eval([varname{iv} '=zeros(nx_p,ny_p,12); ' ]);
end
for iy=yearstart:yearstop;
    disp(iy)

for im=1:12
    disp(im)

read_field_parent
    
    for iv=[1 3];
    if ll(iv)==1;
    eval(['VV=' nemoname{iv} ';']);
 %   VV(D_dom==0)=NaN;
    VV(1,:)=NaN;
    VV(:,1)=NaN;
    VV(nx_p,:)=NaN;
    VV(:,ny_p)=NaN;
    eval([varname{iv} '(:,:,im) =' varname{iv} '(:,:,im)+VV ;']);
    end
    end
    
 
end
end
%%
for im=1:12
    for iv=[1 3]; 
 eval([varname{iv} '(:,:,im) =' varname{iv} ' (:,:,im)/nyear;';])
    end
end
%%
n_it=5;
% Map to Domain grid % 
% copied form make initiail condition this should be a script or function
sss_dom_pr=zeros(nx,ny,12);
sst_dom_pr=zeros(nx,ny,12);
sst_m(~isfinite(sst_m))=0;
sss_m(~isfinite(sss_m))=0;

sss_m1=sss_m;
sst_m1=sst_m;

for i_it=1:n_it %number of cells to flood 
ir=2:nx_p-1;
jr=2:ny_p-1;
for k=1:12;   
[I J] = find(sss_m(ir,jr,k)==0 & (sss_m(ir+1,jr,k) ~= 0 | sss_m(ir-1,jr,k) ~= 0 + ...
                                   sss_m(ir,jr+1,k) ~= 0 | sss_m(ir,jr-1,k) ~= 0) );
I=I+1;
J=J+1;
II=I+(J-1)*nx_p; 

for ii=1:length(I);
i=I(ii);j=J(ii);

norm=(double(sss_m(i+1,j,k)~=0) + double(sss_m(i-1,j,k)~=0) + double(sss_m(i,j+1,k)~=0) + double(sss_m(i,j-1,k)~=0));
sss_m1(i,j,k)= sss_m(i+1,j,k) + sss_m(i-1,j,k) + sss_m(i,j+1,k) + sss_m(i,j-1,k);
sst_m1(i,j,k)= sst_m(i+1,j,k) + sst_m(i-1,j,k) + sst_m(i,j+1,k) + sst_m(i,j-1,k);
sss_m1(i,j,k)= sss_m1(i,j,k)/norm;
sst_m1(i,j,k)= sst_m1(i,j,k)/norm;

end
end
sss_m=sss_m1;
sst_m=sst_m1;
end

sst_m(sss_m==0)=NaN;
sss_m(sss_m==0)=NaN;
%%
sss_dom_pr=zeros(nx,ny,12);
sst_dom_pr=zeros(nx,ny,12);
for iw=1:4;
V{iw}=zeros(nx,ny,12);
end
for iw=1:4;
W{iw}=zeros(nx,ny,12);
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


Wtmp=W;
for iw=1:4
W{iw}=Wtmp{iw}./(Wtmp{1}+Wtmp{2}+Wtmp{3}+Wtmp{4});
end
for iw=1:4
for j=1:ny;
for i=1:nx;
ii=i+(j-1)*nx;
V{iw}(i,j,:)=sss_m(II(iw,ii),JJ(iw,ii),:);
V{iw+4}(i,j,:)=sst_m(II(iw,ii),JJ(iw,ii),:);
end
end
end
if(0)
for iw=1:4;
V{iw}( ~isfinite(V{iw}))=0;
V{iw+4}( ~isfinite(V{iw+4}))=0;
W{iw}( ~isfinite(V{iw}))=0;
end
end
%normalise
Wtmp=W;
for iw=1:4
W{iw}=Wtmp{iw}./(Wtmp{1}+Wtmp{2}+Wtmp{3}+Wtmp{4});
end

for iw=1:4
sss_dom_pr=sss_dom_pr+V{iw}.*W{iw};
sst_dom_pr=sst_dom_pr+V{iw+4}.*W{iw};
end


for i=1:12
DD(:,:,i)=D_dom;
end
sss_dom_pr(DD==0)=NaN;
sst_dom_pr(DD==0)=NaN;


%%



%%%

nemo_name=[assess_path 'TSclim_' DOMNAM '_parent.mat'];
save(nemo_name, 'sss_dom_pr', 'sst_dom_pr');



