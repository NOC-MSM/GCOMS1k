
rivfilename=[domain_path  '/' DOMNAM '/' DOMNAM '_rivertest_v3.nc'];
check_delete(rivfilename);

%%
% single domain verison
rho0=1000;
nx=size(D,1);
ny=size(D,2);
mnth=0;
rorunoff=zeros(nx,ny,12);  % value of dummy variable
 for i=1:length(i_r);
     if ~mnth
     rorunoff(i_r(i),j_r(i),:)=river_data(i,4)*rho0/(e1t(i_r(i),j_r(i)).*e2t(i_r(i),j_r(i)));
     else
     for im=1:12;
       rorunoff(i_r(i),j_r(i),im)=river_data(i,4)*rho0/(e1t(i_r(i),j_r(i)).*e2t(i_r(i),j_r(i)))*river_data(i,4+im);  
     end
     end
 end
 

 %fixes
if strcmp(DOMNAM,'BLZE12');
 rr=rorunoff(156,61,1);
rorunoff(156,61,:)=rr/3;
rorunoff(157,61,:)=rr/3;
rorunoff(158,61,:)=rr/3;

rr=rorunoff(111,22,:);
rorunoff(111,22,:)=rr/3;
rorunoff(112,22,:)=rr/3;
rorunoff(113,22,:)=rr/3;
end
if strcmp(DOMNAM,'HBOB34_1k');
   rr=rorunoff(454,174,1);
ii=[454 455 456 451 452 453 448 449 450]; 
jj=[174 174 174 175 175 175 176 176 176];
nr=length(ii);
for i=1:nr;
rorunoff(ii(i),jj(i),:)=rr/nr;
end
end

 %%
 
 output=rivfilename;
nccreate(output,'time_counter','Dimensions',{'time_counter',Inf},'Format','netcdf4_classic');
nccreate(output,'lat','Dimensions',{'lat',ny},'Format','netcdf4_classic');
nccreate(output,'lon','Dimensions',{'lon',nx},'Format','netcdf4_classic');
nccreate(output,'rorunoff','Dimensions',{'lon',nx,'lat',ny,'time_counter',12},'Format','netcdf4_classic');
ncwrite(output,'lon',(1:nx));
ncwrite(output,'lat',(1:ny));
ncwrite(output,'rorunoff',rorunoff);
ncwrite(output,'time_counter',(1:12));


