%finds all EN4 profiles in a box x_min - x_max, y_min - y_max
en4_path='/login/jholt/work/data_obs/EN4/';
en4_name='EN.4.0.2.f.profiles.';

lon_en4=[];
lat_en4=[];
tmp_en4=[];
sal_en4=[]
Z_en4=[];
yday_en4=[];
jday_en4=[];
mnth_en4=[];
year_en4=[];
for iy=1977:2014;
    for im=1:12
    disp([iy im])
    mm=num2str(im);if im<10; mm=['0' mm];end
    yy=num2str(iy);
lon1=ncread([en4_path en4_name yy mm '.nc'],'LONGITUDE');
lat1=ncread([en4_path en4_name yy mm '.nc'],'LATITUDE');
tmp1=ncread([en4_path en4_name yy mm '.nc'],'POTM_CORRECTED');
sal1=ncread([en4_path en4_name yy mm '.nc'],'PSAL_CORRECTED');
jday=ncread([en4_path en4_name yy mm '.nc'],'JULD');
Z1=ncread([en4_path en4_name yy mm '.nc'],'DEPH_CORRECTED');
PQC1=ncread([en4_path en4_name yy mm '.nc'],'POSITION_QC');
PPTQC1=ncread([en4_path en4_name yy mm '.nc'],'PROFILE_POTM_QC');
PPSQC1=ncread([en4_path en4_name yy mm '.nc'],'PROFILE_PSAL_QC');
tmp1_QC=ncread([en4_path en4_name yy mm '.nc'],'POTM_CORRECTED_QC');
sal1_QC=ncread([en4_path en4_name yy mm '.nc'],'PSAL_CORRECTED_QC');
tmp1(find(tmp1_QC=='4'))=NaN;
sal1(find(sal1_QC=='4'))=NaN;
yday1=mod(floor(jday),365.25);
I=find(lon1>x_min & lon1 < x_max & lat1>y_min & lat1 < y_max & PQC1 ~='4');
lon_en4=[lon_en4 lon1(I)'];
lat_en4=[lat_en4 lat1(I)'];
Z_en4=[Z_en4 Z1(:,I)];
tmp_en4=[tmp_en4 tmp1(:,I)];
sal_en4=[sal_en4 sal1(:,I)];
yday_en4=[yday_en4 yday1(I)'];
mnth_en4=[mnth_en4 im*ones(length(I),1)'];
year_en4=[year_en4 iy*ones(length(I),1)'];
jday_en4=[jday_en4 jday(I)'];
end
end

en4_dataname=[assess_path 'EN4_profiles_' DOMNAM '.mat'];

save(en4_dataname, 'lon_en4','lat_en4','Z_en4','tmp_en4','sal_en4','yday_en4','jday_en4','mnth_en4','year_en4');



