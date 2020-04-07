
FRQ='1d';
mdays=31; 
isleap= (mod(iy,4)==0 & mod(iy,100)~=0) | mod(iy,400)==0;
if im==4 |  im==6 | im==9 | im==11; mdays=30;end
if im==2; mdays =28; end
if im==2 & isleap ; mdays=29;;end


MDAYS=num2str(mdays);  
    YEAR=num2str(iy);
MNTH=num2str(im);
if im<10; MNTH=['0' MNTH];end
    

Start=[YEAR MNTH '01'];
Stop=[YEAR MNTH MDAYS];
OUTNAME=[FRQ '_' Start '_' Stop];

grids{1}='grid_T'; grids{2}='grid_U'; grids{3}='grid_V'; 


fname_t=[domain_outpath '/' DOMNAM '_' EXPNUM '/' YEAR '/' DOMNAM RUNNAM '_' OUTNAME '_' grids{1} '.nc'];
fname_u=[domain_outpath '/' DOMNAM '_' EXPNUM '/' YEAR '/' DOMNAM RUNNAM '_' OUTNAME '_' grids{2} '.nc'];
fname_v=[domain_outpath '/' DOMNAM '_' EXPNUM '/' YEAR '/' DOMNAM RUNNAM '_' OUTNAME '_' grids{3} '.nc'];



var='sss';
%eval([var '= ncread(fname,\''  var '\');' ]);
if (TS)
thetao=ncread(fname_t,'thetao'); 
soce=ncread(fname_t,'soce');
end
if (SSH)
ssh=ncread(fname_t,'zos');
end
if (UV)
uoce=ncread(fname_u,'uoce');
voce=ncread(fname_v,'voce');
end

