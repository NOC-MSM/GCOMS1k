
A=xlsread([Global_rivers_path 'hypoxic sites 2018 - lat_lon.xlsx']);
xh=A(:,2);
yh=A(:,1);
clear hypxn hypx
%read_lme

for i=1:nlme;
      IN = inpolygon(xh,yh,[S1(i).X],[S1(i).Y]) ;
      hypx(i,1:length(find(IN)))=find(IN)';
      hypxn(find(IN))=i;
end

hypx(hypx==0)=NaN;
ihypx= sum(isfinite(hypx),2);

for i=1:nlme;
    %if ihypx(i)~=0
    name_lme{i}=[num2str(S1(i).LME_NUMBER) ' ' S1(i).LME_NAME];
    %else
    %    name_lme{i}='';
    %end
end
%%
iout=find(hypxn==0);

for j=1:length(iout);
 rr=999999999;
 x1=xh(iout(j));
 y1=yh(iout(j));
 
 for i=1:nlme;
 rx=(S1(i).X-x1)*cos(y1.*pi/180);
 ry=(S1(i).Y-y1);
 rmin(i)=nanmin(sqrt(rx.^2+ry.^2));
 if rmin(i)<rr;
   hypxn(iout(j))=-i;
   rr=rmin(i);
 end
 end
end
 %%
for i=1:nlme;
 I_in(i)=length(find(  hypxn==i));
 I_out(i)=length(find( hypxn==-i));
end

return
%%
A= csvread([Global_rivers_path 'lmes_nutrients_loading_eutrophication_2000 - merged.csv']);
for i=1:nlme;
I=find(A(:,1)==S1(i).LME_NUMBER);
if length(I)~=0
merged_id(i)=A(I,2);
name_lme{i}=[name_lme{i} ':' num2str(merged_id(i))];
end
end

%%

 ipx=1:nlme;
 ipx=find(I_in>0 | I_out > 0 | merged_id > 2);
 b=1:length(ipx)
 a=[I_in(ipx); I_out(ipx)];
  barh(b',a','stacked');
  A=gca;
  A.YTick=1:length(ipx);
  A.YTickLabel=name_lme(ipx);
  ip=40
  text(40,ip,'LME Name : Merged Risk');ip=ip-1
  text(40,ip,'1 : Very Low');ip=ip-1
  text(40,ip,'2 : Low');ip=ip-1
  text(40,ip,'3 : Medium');ip=ip-1
  text(40,ip,'4 : High');ip=ip-1
  text(40,ip,'5 : Very High');ip=ip-1
  legend('In LME','Inshore of LME')
  axis('tight')
  orient landscape
  title({'Number of locations reporting coastal hypoxia (Breitburg et al Science, 2018)','by LME and TWAP Merged Risk Indicator'})
  
  
  
  
  
