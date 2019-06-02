
%Inputs
%bathy fname 'bathy_meter.nc'
%coords_fname 'coordinates.nc'
% nx ny
% D
%e1t e2t
%e1u e2u
%e1v e2v
%e1f e2f
%glaml gphit
%glamu  gphiu
%glamv  gphiv
%glamf  gphif
x_len=nx;
y_len=ny;
fv = NaN;
bathy = D;

check_delete(bathy_fname)
% enter define mode 
    
netcdf.setDefaultFormat('FORMAT_NETCDF4') ;
mode = netcdf.getConstant('CLOBBER') ;
ncid = netcdf.create(bathy_fname,mode) ;
                           
% define dimensions 

dimxID  = netcdf.defDim(ncid,'x' ,x_len ) ;
dimyID  = netcdf.defDim(ncid,'y' ,y_len ) ;

% define variables

varlonID  = netcdf.defVar(ncid,'nav_lon','float',[dimxID, dimyID]) ;
varlatID  = netcdf.defVar(ncid,'nav_lat','float',[dimxID, dimyID]) ;
varbatID  = netcdf.defVar(ncid,'Bathymetry','float',[dimxID, dimyID]) ;

% assign global attributes

NC_GLOBAL = netcdf.getConstant('GLOBAL') ;

netcdf.putAtt(ncid,NC_GLOBAL,'file_name',bathy_fname) ;  
netcdf.putAtt(ncid,NC_GLOBAL,'creation_date',datestr(now)) ;  
netcdf.putAtt(ncid,NC_GLOBAL,'history',' ') ; 
netcdf.putAtt(ncid,NC_GLOBAL,'institution',                             ...
                          'National Oceanography Centre, Livepool, U.K.') ; 

% assign per-variable attributes 

netcdf.putAtt(ncid,varlonID,'axis','Longitude') ;
netcdf.putAtt(ncid,varlonID,'short_name','nav_lon') ;
netcdf.putAtt(ncid,varlonID,'units','degrees_east') ;
netcdf.putAtt(ncid,varlonID,'long_name', 'Longitude') ;

netcdf.putAtt(ncid,varlatID,'axis','Latitude') ;
netcdf.putAtt(ncid,varlatID,'short_name','nav_lat') ;
netcdf.putAtt(ncid,varlatID,'units','degrees_east') ;
netcdf.putAtt(ncid,varlatID,'long_name', 'Latitude') ;
        
netcdf.defVarFill(ncid,varbatID,false,fv);
netcdf.putAtt(ncid,varbatID,'short_name','Bathymetry') ;
netcdf.putAtt(ncid,varbatID,'units','meters') ;
netcdf.putAtt(ncid,varbatID,'long_name', 'Bathymetry') ;

netcdf.endDef(ncid) ;

netcdf.close(ncid) ;

% populate data file

count = size(bathy) 

netcdf.setDefaultFormat('FORMAT_NETCDF4') ;
mode = netcdf.getConstant('WRITE') ;
ncid = netcdf.open(bathy_fname,mode) ;

varid = netcdf.inqVarID(ncid,'Bathymetry') ;
netcdf.putVar(ncid,varid,[0 0],count,bathy) ;
varid = netcdf.inqVarID(ncid,'nav_lon') ;
netcdf.putVar(ncid,varid,[0 0],count,glamt) ;
varid = netcdf.inqVarID(ncid,'nav_lat') ;
netcdf.putVar(ncid,varid,[0 0],count,gphit) ;

netcdf.close(ncid) ;

% coordinate file

grd = {'t','u','v','f'} ;
coord_var = {'e1','e2','glam','gphi'} ;      
%os = [0 0 0 0; 0 0 0.5*dx 0; 0 0 0 0.5*dy; 0 0 0.5*dx 0.5*dy] ; 
% dimension lengths

x_len  = nx% + 2 ;
y_len  = ny% + 2 ;
z_len  = 1 ;
t_len  = 1 ;

% enter define mode 
   check_delete(coords_fname);
netcdf.setDefaultFormat('FORMAT_NETCDF4') ;
mode = netcdf.getConstant('CLOBBER') ;
ncid = netcdf.create(coords_fname,mode) ;
                           
% define dimensions 

dimxID  = netcdf.defDim(ncid,'x' ,x_len ) ;
dimyID  = netcdf.defDim(ncid,'y' ,y_len ) ;
dimzID  = netcdf.defDim(ncid,'z' ,z_len ) ;
dimtID  = netcdf.defDim(ncid,'time' ,t_len ) ;

% define variables

varlonID  = netcdf.defVar(ncid,'nav_lon','float',[dimxID, dimyID]) ;
varlatID  = netcdf.defVar(ncid,'nav_lat','float',[dimxID, dimyID]) ;
varlevID  = netcdf.defVar(ncid,'nav_lev','float',[dimzID]) ;

% assign per-variable attributes 

netcdf.putAtt(ncid,varlonID,'axis','Longitude') ;
netcdf.putAtt(ncid,varlonID,'short_name','nav_lon') ;
netcdf.putAtt(ncid,varlonID,'units','degrees_east') ;
netcdf.putAtt(ncid,varlonID,'long_name', 'Longitude') ;

netcdf.putAtt(ncid,varlatID,'axis','Latitude') ;
netcdf.putAtt(ncid,varlatID,'short_name','nav_lat') ;
netcdf.putAtt(ncid,varlatID,'units','degrees_east') ;
netcdf.putAtt(ncid,varlatID,'long_name', 'Latitude') ;

netcdf.putAtt(ncid,varlevID,'axis','Model Level') ;
netcdf.putAtt(ncid,varlevID,'short_name','nav_lev') ;
netcdf.putAtt(ncid,varlevID,'units','unitless') ;
netcdf.putAtt(ncid,varlevID,'long_name', 'Model Level') ;

% define other variables

for g = 1:length(grd)
    
    for v = 1:length(coord_var)
%        netcdf.defVar(ncid,strcat(coord_var{v},grd{g}),'float',[dimxID, dimyID, dimzID, dimtID]) ;
                netcdf.defVar(ncid,strcat(coord_var{v},grd{g}),'float',[dimxID, dimyID]);
    end
    
end

netcdf.endDef(ncid) ;

netcdf.close(ncid) ;

% populate data file

count = size(bathy) 

netcdf.setDefaultFormat('FORMAT_NETCDF4') ;
mode = netcdf.getConstant('WRITE') ;
ncid = netcdf.open(coords_fname,mode) ;

varid = netcdf.inqVarID(ncid,'nav_lon') ;
netcdf.putVar(ncid,varid,[0 0],count,glamt) ;
varid = netcdf.inqVarID(ncid,'nav_lat') ;
netcdf.putVar(ncid,varid,[0 0],count,gphit) ;

for g = 1:length(grd)
    
    for v = 1:length(coord_var)
   
        varid = netcdf.inqVarID(ncid,strcat(coord_var{v},grd{g})) ;
%        eval(['netcdf.putVar(ncid,varid,[0 0 0 0],[count 1 1],[' num2str(os(g,v)) ' + ' strcat(coord_var{v},grd{1}) ''']) ;'])
         eval(['netcdf.putVar(ncid,varid,[0 0],[count], ' strcat(coord_var{v},grd{1}) ' );'])
    end
    
end
 
netcdf.close(ncid) ;
