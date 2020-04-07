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
TS=1;
SSH=0;
domain_grid

varname{1}='sst';
varname{2}='sbt';
varname{3}='sss';
varname{4}='sbs';
nemoname{1}='thetao';
nemoname{3}='soce';
ll(3)=1;
ll(1)=1;

im=1:12;
yearstart=1995;
yearstop=1995;
nyear = yearstop-yearstart+1;
for iv=[1 3];
 eval([varname{iv} '=zeros(nx,ny,12); ' ]);
end
for iy=yearstart:yearstop;
    disp(iy)

outpath=[   domain_outpath '/' DOMNAM '_' EXPNUM  '/']; 
for im=1:12
    disp(im)

    read_field
    
    for iv=[1 3];
    if ll(iv)==1;
    eval(['VV=squeeze(mean(' nemoname{iv} '(:,:,ll(iv),:),4));']);
    VV(D_dom==0)=NaN;
    VV(1,:)=NaN;
    VV(:,1)=NaN;
    VV(nx,:)=NaN;
    VV(:,ny)=NaN;
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

nemo_name=[assess_path 'TSclim_' DOMNAM '.mat'];
save(nemo_name, 'sst','sss');





