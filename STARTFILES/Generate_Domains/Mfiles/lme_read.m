
S1=shaperead([lme_path 'LME66.shx']);

x0=999;
x1=-999;
y0=999;
y1=-999;
nn=[];
nlme=length(S1);
for ilme=1:nlme;
if sum(S1(ilme).LME_NUMBER==iwant_LMEs);
xy=S1(ilme).BoundingBox;
x0=min([x0 xy(1,1)]);
x1=max([x1 xy(2,1)]);
y0=min([y0 xy(1,2)]);
y1=max([y1 xy(2,2)]);
nn=[nn num2str(S1(ilme).LME_NUMBER) '_'];
end
end