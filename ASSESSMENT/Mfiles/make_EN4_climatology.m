%Bins EN4 data on to model grid ot make monthly climatatology
% Calculates
% sst_en4  : sea surface temperature
% sbt_en4  : sea bed temperature
% sss_en4  : sea surface salinity
% sbs_en4  : sea bed salinity

% Needs
% assess_path : place to read data and write output
% DOMNAM      : name of region
% nx, ny size of model grid
% lon_dom(nx,ny) lat_dom(ny,ny) model grid coordiates (degs)
% dx_dom(nx,ny)  dy_dom(nx,ny)  modle grid spacing (m)

Re=6367456.0*pi/180; % radius of Earth
dZ=20; %30m

en4_dataname=[assess_path 'EN4_profiles_' DOMNAM '.mat'];

load (en4_dataname)

sst_en4=zeros(nx,ny,12);
sss_en4=zeros(nx,ny,12);
sbt_en4=zeros(nx,ny,12);
sbs_en4=zeros(nx,ny,12);

nsst_en4=zeros(nx,ny,12);
nsss_en4=zeros(nx,ny,12);
nsbt_en4=zeros(nx,ny,12);
nsbs_en4=zeros(nx,ny,12);

for i=1:nx;
    disp(i)
    for j=1:ny
        if D_dom(i,j)~=0 & isfinite(D_dom(i,j))
            dxx=0.5*dx_dom(i,j)/(Re*cos(lat_dom(i,j)*pi/180));
            dyy=0.5*dy_dom(i,j)/(Re);
           for im=1:12;
            I= find(abs(lon_dom(i,j) - lon_en4) < dxx & ...
                    abs(lat_dom(i,j) - lat_en4) < dyy & ...
                    im == mnth_en4 );
            for ii=1:length(I);
               Is=find(Z_en4(:,I(ii))<dZ) ;
               Ib=find(D_dom(i,j)-Z_en4(:,I(ii))<dZ) ;
             %SST  
             Ts=nanmean(tmp_en4(Is,I(ii)));
             if isfinite(Ts);
                 sst_en4(i,j,im)= sst_en4(i,j,im) + Ts;
                 nsst_en4(i,j,im)= nsst_en4(i,j,im) + 1;
             end
             %SSS
             Ss=nanmean(sal_en4(Is,I(ii)));
             if isfinite(Ss);
               disp([i,j,Ss])
                 sss_en4(i,j,im)= sss_en4(i,j,im) + Ss;
                 nsss_en4(i,j,im)= nsss_en4(i,j,im) + 1;
             end
             %SBT  
             Tb=nanmean(tmp_en4(Ib,I(ii)));
             if isfinite(Tb);
                 sbt_en4(i,j,im)= sbt_en4(i,j,im) + Tb;
                 nsbt_en4(i,j,im)= nsbt_en4(i,j,im) + 1;
             end
             %SBS
             Sb=nanmean(sal_en4(Ib,I(ii)));
             if isfinite(Sb);
                 sbs_en4(i,j,im)= sbs_en4(i,j,im) + Sb;
                 nsbs_en4(i,j,im)= nsbs_en4(i,j,im) + 1;
             end
 %Add other parameters here        
             
            end    
            end
               
           end
           
    end
end

sst_en4=sst_en4./nsst_en4;
sbt_en4=sbt_en4./nsbt_en4;
sss_en4=sss_en4./nsss_en4;
sbs_en4=sbs_en4./nsbs_en4;

sst_en4(nsst_en4==0)=NaN;
sss_en4(nsss_en4==0)=NaN;

en4_name=[assess_path 'EN4clim_' DOMNAM '.mat'];
save(en4_name, 'sst_en4','sss_en4', 'sbt_en4','sbs_en4');




