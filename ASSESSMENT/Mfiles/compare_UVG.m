if(1)
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
nc=144
ugi=ones(nxg,nyg,nc)*NaN;
vgi=ones(nxg,nyg,nc)*NaN;
spi=ones(nxg,nyg,nc)*NaN;
ugip=ones(nxg,nyg,nc)*NaN;
vgip=ones(nxg,nyg,nc)*NaN;
spip=ones(nxg,nyg,nc)*NaN;

%%
end
latl=lat_dom(:);
lonl=lon_dom(:);
DD=D_dom(:);
nc=size(Ugm,3)
nc=144;
for j=1:nyg

for i=1:nxg
    if abs(lat_uvgex(i,j))>5
    if isfinite(vgosm(i,j,1));
    I=find(abs(lon_uvgex(i,j)-lonl)<dx/2 & abs(lat_uvgex(i,j)-latl)<dy/2 &  DD~=0);
    for ic=1:nc;
    ugmm=Ugm(:,:,ic);
    vgmm=Vgm(:,:,ic);
    ugi(i,j,ic)=nanmean(ugmm(I));
    vgi(i,j,ic)=nanmean(vgmm(I));  
    
    end
    end
end
    end
end
%%
latl=lat_prntex(:);
lonl=lon_prntex(:);

for j=1:nyg

for i=1:nxg
    if abs(lat_uvgex(i,j))>5
    if isfinite(vgosm(i,j,1));
    I=find(abs(lon_uvgex(i,j)-lonl)<dx/2 & abs(lat_uvgex(i,j)-latl)<dy/2 );
    for ic=1:nc;
    ugmm=Ugmp(:,:,ic);
    vgmm=Vgmp(:,:,ic);
    ugip(i,j,ic)=nanmean(ugmm(I));
    vgip(i,j,ic)=nanmean(vgmm(I));  
    
    end
    end
end
    end
end


%%

ic=1:nc;
spi=sqrt(ugi.^2+vgi.^2);
spip=sqrt(ugip.^2+vgip.^2);
spi(spi>3)=NaN;
spip(spip>3)=NaN;
spgos=sqrt(ugosm(:,:,ic).^2+vgosm(:,:,ic).^2);
%%
clear spim spipm spgosm
for im=1:12;
spim(:,:,im)=mean(spi(:,:,im:12:end),3);
spipm(:,:,im)=mean(spip(:,:,im:12:end),3);
spgosm(:,:,im)=mean(spgos(:,:,im:12:end),3);
end



I=find(isfinite(spim) & isfinite(spgosm));
cc=corrcoef(spim(I),spgosm(I));
mdev=mean(spim(I)-spgosm(I));
rmsdev=sqrt(mean((spim(I)-spgosm(I)).^2));
chi=rmsdev./nanstd(spgosm(I));

I=find(isfinite(spipm) & isfinite(spgosm) & isfinite(spim));
ccp=corrcoef(spipm(I),spgosm(I));
mdevp=mean(spipm(I)-spgosm(I));
rmsdevp=sqrt(mean((spipm(I)-spgosm(I)).^2));
chip=rmsdevp./nanstd(spgosm(I));



figure(1)
subplot(211)
plot(spim(:),spgosm(:),'.',[0 1.2],[0 1.2]);
xlabel('Model (ms.^{-1})');
ylabel('CMEMS UVG (ms.^{-1})')
title([DOMNAM ' Surface Geostrophic Current Speed Mean Month' ])

text(.2,1.0,['Merr=' num2str(mdev,2) 'ms.^{-1}']);
text(.2,0.9,['R2=' num2str(cc(1,2).^2,2) ]);
text(.2,0.8,['RMSE=' num2str(rmsdev,2) 'ms.^{-1}' ]);
text(.2,0.7,['RMSE/\sigma_o=' num2str(chi,2)  ]);

subplot(212)
plot(spipm(I),spgosm(I),'.',[0 1.2],[0 1.2]);
xlabel('Model (ms.^{-1})');
ylabel('CMEMS UVG (ms.^{-1})')
title([DOMNAM ' Surface Geostrophic Current Speed Mean Month ORCA0083' ])

text(.2,1.0,['Merr=' num2str(mdevp,2) 'ms.^{-1}']);
text(.2,0.9,['R2=' num2str(ccp(1,2).^2,2) ]);
text(.2,0.8,['RMSE=' num2str(rmsdevp,2) 'ms.^{-1}' ]);
text(.2,0.7,['RMSE/\sigma_o=' num2str(chip,2)  ]);
orient tall
eval(['print UVG_cmp_MM_' DOMNAM '.png -r300 -dpng'])


