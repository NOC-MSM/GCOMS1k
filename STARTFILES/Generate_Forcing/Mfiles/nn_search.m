function [i_out, j_out,nnid] = nn_search(src_i,src_j,dst_i,dst_j)

% Returns the 4 closest points to the given lat and lon
%
% NB need to execute:
%  addpath(genpath('/login/jdha/matlab/new_matlab/utilities/ann_mwrapper')) ;
% to pick up the path to the underlying c-program
%
% Example of use
% 
% nc = netcdf('/projectsa//Eurobasin/bathy/ORCA_R12/ORCA_R12_bathy_meter.nc');
% src_i=nc{'nav_lon'}(:);
% src_j=nc{'nav_lat'}(:);
% close(nc)
% x=ones(100000,1)*20.123;
% y=ones(100000,1)*56.123;
% [i_out, j_out, nnid] = nn_search(src_i,src_j,x,y);
% 
% % returns i/j indices
% 
% for k = 1:4
%   [ src_i(j_out(k,1),i_out(k,1)),  src_j(j_out(k,1),i_out(k,1))]
% end
% 
% % or array index
% 
% for k = 1:4
%   [ src_i(nnid(k,1)),  src_j(nnid(k,1))]
% end

% find the nearest neighbour 

src_dims = size(src_i) ;

nnid = annquery([src_i(:), src_j(:)]', [dst_i(:), dst_j(:)]', 4) ;
nnid = double(nnid) ;

[j_out,i_out] = ind2sub(src_dims,nnid) ;

