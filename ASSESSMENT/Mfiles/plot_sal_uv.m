




dxm=diff(x);
dxm=mean(dxm(:));
dym=diff(y');
dym=mean(dym(:));

i=2:nx;
j=2:ny;
sss_m=mean_field(sss,it);
uu=mean_field(ssu,it);
vv=mean_field(ssv,it);

clear ssu_mg
ssu_mg(i,:)=0.5*(uu(i,:)+uu(i-1,:));


clear ssv_mg
ssv_mg(:,j)=0.5*(vv(:,j)+vv(:,j-1));


ssu_m=ssu_mg.*gcos-ssv_mg.*gsin;
ssv_m=ssv_mg.*gcos+ssu_mg.*gsin;

I=find(sss_m==0);
sss_m(I)=NaN;
ssu_m(I)=NaN;
ssv_m(I)=NaN;

i=i0:i1;
j=j0:j1;

ii=i0:np:i1;
jj=j0:np:j1;

xx=x(i,j);
yy=y(i,j);
x0=min(xx(:));
x1=max(xx(:));
y0=min(yy(:));
y1=max(yy(:));

clf
m_proj('Mercator','longitudes',[x0 x1],'latitudes',[y0 y1])
[X,Y]=m_ll2xy(xx-0.5*dxm,yy-0.5*dym);
[Xu,Yu]=m_ll2xy(x(ii,jj),y(ii,jj));

pcolor(X,Y,sss_m(i,j));shading flat
caxis(salrange)
hold on
quiver(Xu,Yu,Sc*ssu_m(ii,jj),Sc*ssv_m(ii,jj),0)
m_gshhs_h('patch',[0.7 0.7 0.7]);

%[Xu_sc,Yu_sc]=m_ll2xy(xu_sc,yu_sc);
%quiver(Sc*Xu_sc,Sc*Yu_sc,Uscale,0,0);

%m_gshhs('fc','patch',[0.7 0.7 0.7]);
%m_gshhs('fr');
%m_gshhs('fb1','color','k');

hold off
% can give error without turning off axis ticks.
m_grid('tickstyle','dd','xtick',[],'ytick',[])
