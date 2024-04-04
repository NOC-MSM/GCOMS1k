import xarray as xr
import numpy as np

def sub_sample_2d(mesh,nn):
    ny,nx=mesh.shape
    ny_new=np.floor(ny/nn).astype('int')
    nx_new=np.floor(nx/nn).astype('int')
    mesh_new=np.zeros((ny_new,nx_new))
    for j in range(ny_new):
        for i in range(nx_new):
            J=range(j*nn,(j+1)*nn)
            I=range(i*nn,(i+1)*nn)
            mm=mesh[J,I].ravel()
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

def rotate_on_sphere (lon,lat,lon_axis,lat_axis,rotation):

#from https://stevedutch.net/mathalgo/sphere0.htm


    c1 = np.cos(lat_axis) * np.cos(lon_axis) #x axis
    c2 = np.cos(lat_axis) * np.sin(lon_axis) #y axis
    c3 = np.sin(lat_axis)          #z axis

    x' = x cos a + (1 - cos a)(c1c1x + c1c2y + c1c3z) + (c2z - c3y)sin a
    y' = y cos a + (1 - cos a)(c2c1x + c2c2y + c2c3z) + (c3x - c1z)sin a
    z' = z cos a + (1 - cos a)(c3c1x + c3c2y + c3c3z) + (c1y - c2x)sin a


    lat_p = 

class basin:
    def __init__(self, global_bathyname,limits,resolution):
        self.global_bathyname=global_bathyname
        self.limit=limits
        self.resolution=resolution
        print(self.global_bathyname)
        print(limits)
        lat_min, lat_max, lon_min, lon_max = limits
        f = xr.open_dataset(self.global_bathyname)
        jmin = np.argmin((f.lat.values - lat_min) ** 2)
        jmax = np.argmin((f.lat.values - lat_max) ** 2)
        imin = np.argmin((f.lon.values - lon_min) ** 2)
        imax = np.argmin((f.lon.values - lon_max) ** 2)

        self.bathy_basin_raw=f.isel(lat=range(jmin, jmax),lon=range(imin, imax))
        #bathy_basin_raw = -np.ma.masked_where(self.bathy_basin_raw.elevation>0,
        #                                 self.bathy_basin_raw.elevation)

        bathy_basin_raw = -self.bathy_basin_raw.elevation.values[:,:]
        bathy_basin_raw[self.bathy_basin_raw.elevation>0] = np.nan

        bathy_basin=sub_sample_2d( bathy_basin_raw,resolution)
        print(bathy_basin_raw.shape)
        print(bathy_basin.shape)
        lat_basin=sub_sample_1d(self.bathy_basin_raw.lat.values[:],resolution)
        lon_basin=sub_sample_1d(self.bathy_basin_raw.lon.values[:],resolution)
        self.dataset=xr.Dataset(coords=dict(
                                        lat=("y_dim", lat_basin),
                                        lon=("x_dim",lon_basin)
                        ))
        self.dataset['bathymetry']=xr.DataArray(
                bathy_basin,
                dims=["y_dim", "x_dim"])

    def classify (shelfbreak=200,)
class domain:
    def __init__(self, basin,limits,resolution):
        self.limits = limits
        self.resolution = resolution

