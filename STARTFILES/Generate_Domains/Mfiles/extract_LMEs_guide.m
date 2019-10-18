environment

figure(1)
read_lme
hypoxia_region_in_LME;
big_Nrivers_in_LME
iwant_LMEs=[32 34];
id=0;clear dom
for i=1:length(iwant_LMEs);
    ii=ilme_inx(iwant_LMEs(i))
   disp( [ S1(ii).LME_NAME ' : ' num2str(iwant_LMEs(i))])
    xx=S1(ii).X;
    yy=S1(ii).Y;
 plot(xx,yy);
 hold on
  I=find(isfinite(hypx(ii,:)));
plot (xh(hypx(ii,I)), yh(hypx(ii,I)),'xb','markersize',20)
 I=find(isfinite(Nriv(ii,:)));
plot (xr(Nriv(ii,I)), yr(Nriv(ii,I)),'ok','markersize',20)
inp='y';
while inp=='y'
inp=input('Add a domain: y/n [n]','s');
if inp=='y';
ID=input('Identifier:','s');
id=id+1;
dom{id}=ID;
end

end

inp=input('Extract bathy for this group: y/n [n]','s');
if inp=='y';
extract_LMEs_bathyfile
end



for idom=1:id;
  inp=input(['Run GridBuilder for : ' dom{idom} ' in ' S1(ii).LME_NAME ' y/n [n]'],'s');
  if inp=='y'
  GridBuilder
  pause
 % DOMNAM=['GCOMS1k_LME_' num2str(S1(ii).LME_NUMBER) '_' dom{idom}];flipit=0;
%  DOMNAM=[dom{idom} num2str(S1(ii).LME_NUMBER) '_1k'];
DOMNAM=dom{idom};
GridBuilder_to_NEMO;

  end
  
  
  
end

end
hold off




