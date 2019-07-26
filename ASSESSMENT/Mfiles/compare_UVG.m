if(0)
UVG_name=[assess_path DOMNAM '/UVg_mnth_' DOMNAM '_UVG.mat'];
load(UVG_name);
nemo_name=[assess_path  DOMNAM '/UVg_mnth_' DOMNAM '_ORCA0083.mat'];
load(nemo_name);
Ugmp=Ugm;
Vgmp=Vgm;
nemo_name=[assess_path  DOMNAM '/UVg_mnth_' DOMNAM '.mat'];
load(nemo_name);
dx=0.25;
dy=0.25;
[nxg,nyg,nc]=size(vgosm(:,:,:));

ugi=ones(nxg,nyg,nc)*NaN;
vgi=ones(nxg,nyg,nc)*NaN;
spi=ones(nxg,nyg,nc)*NaN;
%%
end
latl=lat_dom(:);
lonl=lon_dom(:);
DD=D_dom(:);

for j=1:nyg
%    if abs(lat_uvgex(i,j))>5
for i=1:nxg
    if isfinite(vgosm(i,j,1));
    I=find(abs(lon_uvgex(i,j)-lonl)<dx/2 & abs(lat_uvgex(i,j)-latl)<dy/2 &  DD~=0);
    for ic=1:nc;
    ugmm=Ugm(:,:,ic);
    vgmm=Vgm(:,:,ic);
    ugi(i,j,ic)=nanmean(ugmm(I));
    vgi(i,j,ic)=nanmean(vgmm(I));  
    
    end
    end
%end
    end
end
%%
latl=lat_prntex(:);
lonl=lon_prntex(:);

for j=1:nyg
%    if abs(lat_uvgex(i,j))>5
for i=1:nxg
    if isfinite(vgosm(i,j,1));
    I=find(abs(lon_uvgex(i,j)-lonl)<dx/2 & abs(lat_uvgex(i,j)-latl)<dy/2 );
    for ic=1:nc;
    ugmm=Ugmp(:,:,ic);
    vgmm=Vgmp(:,:,ic);
    ugip(i,j,ic)=nanmean(ugmm(I));
    vgip(i,j,ic)=nanmean(vgmm(I));  
    
    end
    end
%end
    end
end



%%


spi=sqrt(ugi.^2+vgi.^2);
spip=sqrt(ugip.^2+vgip.^2);
spi(spi>3)=NaN;
spip(spip>3)=NaN;
spgos=sqrt(ugosm.^2+vgosm.^2);
I=find(isfinite(spi) & isfinite(spgos));
cc=corrcoef(spi(I),spgos(I));
mdev=mean(spi(I)-spgos(I));
rmsdev=sqrt(mean((spi(I)-spgos(I)).^2));
chi=rmsdev./nanstd(spgos(I));

I=find(isfinite(spip) & isfinite(spgos));
ccp=corrcoef(spip(I),spgos(I));
mdevp=mean(spip(I)-spgos(I));
rmsdevp=sqrt(mean((spip(I)-spgos(I)).^2));
chip=rmsdevp./nanstd(spgos(I));




figure(1)
subplot(211)
plot(spi(:),spgos(:),'.',[0 1.2],[0 1.2]);
xlabel('Model (ms.^{-1})');
ylabel('CMEMS UVG (ms.^{-1})')
title([DOMNAM ' Surface Geostrophic Current Speed 1995-2006' ])

text(.2,1.7,['Merr=' num2str(mdev,2) 'ms.^{-1}']);
text(.2,1.6,['R2=' num2str(cc(1,2).^2,2) ]);
text(.2,1.5,['RMSE=' num2str(rmsdev,2) 'ms.^{-1}' ]);
text(.2,1.4,['RMSE/\sigma_o=' num2str(chi,2)  ]);

subplot(212)
plot(spip(:),spgos(:),'.',[0 1.2],[0 1.2]);
xlabel('Model (ms.^{-1})');
ylabel('CMEMS UVG (ms.^{-1})')
title([DOMNAM ' Surface Geostrophic Current Speed 1995-2006 ORCA0083' ])

text(.2,1.7,['Merr=' num2str(mdevp,2) 'ms.^{-1}']);
text(.2,1.6,['R2=' num2str(ccp(1,2).^2,2) ]);
text(.2,1.5,['RMSE=' num2str(rmsdevp,2) 'ms.^{-1}' ]);
text(.2,1.4,['RMSE/\sigma_o=' num2str(chip,2)  ]);
orient tall
print(['UVG_cmp_' DOMNAM '.png','-r300','-dpng'])


