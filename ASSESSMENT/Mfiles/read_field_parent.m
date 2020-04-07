Year=num2str(iy);
MNTH=num2str(im);

if im<10; MNTH=['0' MNTH];end

parent_path='/work/jholt/JASMIN/NEMO-ORCA0083-N006/';

outname=[parent_path Year '/ORCA0083-N06_' Year 'm' MNTH 'T.nc'];
start2d=[I1 J1 1];
count2d=[length(i) length(j)  1];
%just sea surface salintiy for now
if TS
sss=ncread(outname,'sss',start2d,count2d);
sst=ncread(outname,'sst',start2d,count2d);
end
if SSH 
ssh=ncread(outname,'ssh',start2d,count2d);
end