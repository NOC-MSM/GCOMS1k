 S1=shaperead([lme_path 'LME66.shx']);
nlme=length(S1);
for i=1:nlme;
      ilme_inx(S1(i).LME_NUMBER)=i;
end