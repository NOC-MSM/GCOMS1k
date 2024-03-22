import xarray as xr
import numpy as np

def sub_sample_2d(mesh,nn):
    ny,nx=mesh.shape
    ny_new=np.floor(ny/nn).astype('int')
    nx_new=np.floor(nx/nn).astype('int')
    mesh_new=np.zeros((ny_new,nx_new))
    for j in range(ny_new):
        for i in range(nx_new):
            mm=mesh[j:j+nn,i:i+nn].ravel()
            mesh_new[j,i]=np.nanmean(mm)
    return mesh_new

def sub_sample_1d(vector,nn):
    nx,=vector.shape
    nx_new=np.floor(nx/nn).astype('int')
    vector_new=np.zeros((nx_new))
    for i in range(nx_new):
        mm=vector[i:i+nn].ravel()
        vector_new[i]=np.nanmean(mm)
    return vector_new

class gcoms1k:
    def __init__(self,global_bathyname):
        self.global_bathyname=global_bathyname
        print(self.global_bathyname)


    def basin(self,limits,resolution):
        print(limits)
        lat_min, lat_max, lon_min, lon_max = limits
        f = xr.open_dataset(self.global_bathyname)
        jmin = np.argmin((f.lat.values - lat_min) ** 2)
        jmax = np.argmin((f.lat.values - lat_max) ** 2)
        imin = np.argmin((f.lon.values - lon_min) ** 2)
        imax = np.argmin((f.lon.values - lon_max) ** 2)

        self.basin_bathy=f.isel(lat=range(jmin, jmax),lon=range(imin, imax))
        bathymetry_raw = -np.ma.masked_where(self.basin_bathy.elevation>0,self.basin_bathy.elevation)


        bathymetry=sub_sample_2d( bathymetry_raw,resolution)
        print(bathymetry_raw.shape)
        print(bathymetry.shape)
        lat=sub_sample_1d(self.basin_bathy.lat.values[:],resolution)
        lon=sub_sample_1d(self.basin_bathy.lon.values[:],resolution)
        self.basin_bathy['bathymetry']=xr.DataArray(
                bathymetry,
                dims=["lat", "lon"])