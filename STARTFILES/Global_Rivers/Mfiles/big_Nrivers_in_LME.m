
fid=fopen([Global_rivers_path 'mouth_coordinates.csv']);
fgets(fid);
%[id dum yr dum xr]
A = fscanf(fid,'%f%c%f%c%f',[5,inf]);
id=A(1,:);
xr=A(3,:);
yr=A(5,:);

fid=fopen([Global_rivers_path 'discharge.csv']);
fgets(fid);
format='%f';
tt=1900:5:2000;
nt=length(tt);
for i=tt;
format=[format '%c%f'];
end
A = fscanf(fid,format,[2*nt+1 inf]);
rnf=A(2*(1:nt)+1,:);

fid=fopen([Global_rivers_path 'Nload.csv']);
fgets(fid);
A = fscanf(fid,format,[2*nt+1 inf]);
Nload=A(2*(1:nt)+1,:);


 S1=shaperead([lme_path 'LME66.shx']);
nlme=length(S1);

Nl=Nload(21,:);



Nload1=prctile(Nl,15);
Nl(Nl<Nload1)=NaN;
J=find(isfinite(Nl));

Nload75=prctile(Nl(J),95);
I=find(Nl>Nload75);
xr=xr(I);
yr=yr(I);
clear Nriv
for i=1:nlme;
    
      IN = inpolygon(xr,yr,[S1(i).X],[S1(i).Y]) ;
      Nriv(i,1:length(find(IN)))=find(IN)'; %globally significant rivers
end
Nriv(Nriv==0)=NaN;


return





rnfm=mean(rnf);
Nloadm=mean(Nload);
scatter(xr(i),yr(i),10,rnfm(i));
rnfms=sort(rnfm,1,'descend');
I=find(isfinite(rnfms))
cs_rnfms=cumsum(rnfms(I))./sum(rnfms(I));
Nloads=sort(Nloads,1,'descend');
I=find(isfinite(Nloads))
cs_Nloads=cumsum(Nloads(I))./sum(Nloads(I));
find(cc<0.95,1,'last')

%%
%fid=fopen('basin_id.asc');
