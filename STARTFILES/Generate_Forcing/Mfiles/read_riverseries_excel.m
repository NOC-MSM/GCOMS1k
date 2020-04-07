%Reads river data provided in excel and outputs as .mat file
%This only works on computer with excel installed

DOMNAM='BLZE12'
pname='C:\Users\jholt\OneDrive - NERC\Work\GCOMS1k\INPUTS\'
fname='doublerunQ_xl.xlsx';


filename=[pname '/' DOMNAM '\RiverData\BZriver_reformattedQ_cb_forNOC\' fname];
sheet='doublerunQ';

outname=[pname '/' DOMNAM '\RiverData\' sheet '.mat']

[num,txt,raw]=xlsread(filename,sheet);
date_col=3;
flow_col=4;
start=2;
days=[0 31 28 31 30 31 30 31 31 30 31 30 31]
cdays=cumsum(days)
np=size(raw,1)-(start-1)

for ip=start:np+(start-1)
    ipp=ip-(start-1)
date=raw{ip,date_col};
FLW=raw{ip,flow_col};
if ~ischar(FLW)
flw(ipp)=FLW;
else
flw(ipp)=NaN;
end
day(ipp)=str2num(date(1:2));
mnt(ipp)=str2num(date(4:5));
yr(ipp)=str2num(date(7:10));

if mnt(ipp)==1
 yday(ipp)=day(ipp)   ;
else
 yday(ipp)=day(ipp)+cdays(mnt(ipp));
end
end
save(outname,'yday','day','mnt','yr','flw')
