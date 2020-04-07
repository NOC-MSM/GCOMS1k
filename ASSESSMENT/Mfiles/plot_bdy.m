addpath('/work/jholt/Git/GCOMS1k/STARTFILES/Generate_Domains/Mfiles/');
addpath('/work/jholt/Git/GCOMS1k/STARTFILES/Generate_Forcing/Mfiles/');
addpath('/login/jdha/matlab/new_matlab/models/nemo/utilities');
addpath('/login/jdha/matlab/new_matlab/models/nemo/general');
environment
DOMNAM='YLWS48';
EXPNUM='01';
RUNNAM='';
im=7;
iy=1995;
mm=num2str(im);if im<10; mm=['0' mm];end

fname=[domain_path DOMNAM '/bdydta/' DOMNAM '_bdyV_y' num2str(iy) 'm' mm '.nc'];
nbidta=ncread(fname,'nbidta');
nbjdta=ncread(fname,'nbjdta');
Vbc=ncread(fname,'vomecrty');
fname=[domain_path DOMNAM '/bdydta/' DOMNAM '_bdyU_y' num2str(iy) 'm' mm '.nc'];
Ubc=ncread(fname,'vozocrtx');

Is=find(nbjdta==2);

Vsbc=squeeze(Vbc(Is,1,1,:));
Usbc=squeeze(Ubc(Is,1,1,:));