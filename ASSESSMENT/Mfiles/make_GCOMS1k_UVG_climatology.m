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

varname{1}='ssh';
nemoname{1}='ssh';
SSH=1;
TS=0;
UV=0;



ll(3)=1;
ll(1)=1;

im=1:12;
yearstart=1995;
yearstop=2006;
nyear = yearstop-yearstart+1;
nc=12*nyear
Ugm=zeros(nx,ny,nc);
Vgm=zeros(nx,ny,nc);

ic=0;
for iy=yearstart:yearstop;
    disp(iy)

outpath=[   domain_outpath '/' DOMNAM '_' EXPNUM  '/']; 
for im=1:12
    disp(im)
ic=ic+1;
    read_field
    sshm=mean(ssh,3);
    sshm(D_dom==0)=NaN;
    sshm(:,end)=NaN;
     sshm(end,:)=NaN;
   
    i=1:nx-1;
    j=1:ny-1;
    Ug=ones(nx,ny)*NaN;
    Vg=ones(nx,ny)*NaN;
    Vg(i,:)=g.*(sshm(i+1,:)-sshm(i,:))./(dxu_dom(i,:).*fcor(i,:));
    Ug(:,j)=-g.*(sshm(:,j+1)-sshm(:,j))./(dyv_dom(:,j).*fcor(:,j));
    
    Ugm(:,:,ic)=Ugm(:,:,ic)+Ug;
    Vgm(:,:,ic)=Vgm(:,:,ic)+Vg;

    
 
end
end
%%
grid_file=[domain_path  '/' DOMNAM '/' DOMNAM '_domain_cfg.nc'];
[gcos,gsin] = nemo_grid_angle_hacked(grid_file,2:nx,2:ny);
for ic=1:nc
    uu=Ugm(:,:,ic);
    vv=Vgm(:,:,ic);
    Ugm(:,:,ic) = uu.*gcos-vv.*gsin;
    Vgm(:,:,ic) = vv.*gcos+uu.*gsin;
end

Vgm(1:10,:,:)=NaN;
Vgm(nx-9:nx,:,:)=NaN;
Vgm(:,1:10,:)=NaN;
Vgm(:,ny-9:ny,:)=NaN;
Ugm(1:10,:,:)=NaN;
Ugm(nx-9:nx,:,:)=NaN;
Ugm(:,1:10,:)=NaN;
Ugm(:,ny-9:ny,:)=NaN;
nemo_name=[assess_path DOMNAM '/UVg_mnth_' DOMNAM '.mat'];
save(nemo_name, 'Ugm','Vgm');





