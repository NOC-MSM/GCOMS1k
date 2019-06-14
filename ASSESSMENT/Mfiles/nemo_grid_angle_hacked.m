function [gcos,gsin] = nemo_grid_angle(coord_fname,jj,ii) %#ok<INUSL>


%  nemo_grid_angle computes angles between model grid lines and North
%     [GCOS,GSIN] = NEMO_GRID_ANGLE(COORD_FNAME,II,JJ,CD_TYPE) adapted from
%     angle NEMO v3.3.1 routine. sinus and cosinus of the angle between the 
%     north-south axe and the j-direction at t, u, v and f-points. 
%     Computation done on the north stereographic polar plane.
%
%     NB there is no northern fold point adjustment
%
%     In:
%           coord_fname  ! nemo coordinate file
%           ii           ! model zonal indices
%           jj           ! model meridional indices
%           cd_type      ! define the nature of pt2d array grid-points
%
%     Out:
%           gcos           rotation angle transform value
%           gsin           rotation angle transform value
%
%     Example: 
%
%     Author: J Harle (jdha@noc.ac.uk) 24-05-11
%
%     See also  nemo_grid_angle

% get constants

nemo_phycst

% north pole direction & modulous (at t-point)

zlam=ncread(coord_fname,'glamt');
zphi=ncread(coord_fname,'gphit');
zphi =zphi(jj,ii);
zlam =zlam(jj,ii);
zxnpt = 0. - 2. * cos( rad*zlam ) .* tan( rpi/4. - rad*zphi/2. ) ;
zynpt = 0. - 2. * sin( rad*zlam ) .* tan( rpi/4. - rad*zphi/2. ) ;
znnpt = zxnpt.*zxnpt + zynpt.*zynpt ;

% j-direction: v-point segment direction (around t-point)

zlam=ncread(coord_fname,'glamv');
zphi=ncread(coord_fname,'gphiv');
zphh =zphi(jj,ii-1);
zlan =zlam(jj,ii-1);
zlam=zlam(jj,ii);
zphi=zphi(jj,ii);

zxvvt =  2. * cos( rad*zlam ) .* tan( rpi/4. - rad*zphi/2. )   ...
      -  2. * cos( rad*zlan ) .* tan( rpi/4. - rad*zphh/2. ) ;
zyvvt =  2. * sin( rad*zlam ) .* tan( rpi/4. - rad*zphi/2. )   ...
      -  2. * sin( rad*zlan ) .* tan( rpi/4. - rad*zphh/2. ) ;
znvvt = sqrt( znnpt .* ( zxvvt.*zxvvt + zyvvt.*zyvvt )  ) ;
znvvt(znvvt<1.e-14) = 1.e-14 ;

% cosinus and sinus using scalar and vectorial products

gsinx = ( zxnpt.*zyvvt - zynpt.*zxvvt ) ./ znvvt ;
gcosx = ( zxnpt.*zxvvt + zynpt.*zyvvt ) ./ znvvt ;

gsin(jj,ii)=gsinx;
gcos(jj,ii)=gcosx;
