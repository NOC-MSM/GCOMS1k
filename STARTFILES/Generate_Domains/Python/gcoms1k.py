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

def rotate_on_sphere (lat,lon,lat_axis,lon_axis,angle):

#from https://stevedutch.net/mathalgo/sphere0.htm

    pi180=np.pi/180
    rlat_axis = lat_axis * pi180
    rlon_axis = lon_axis * pi180
    rlat = lat * pi180
    rlon = lon * pi180
    rangle = angle *pi180
    c1 = np.cos(rlat_axis) * np.cos(rlon_axis) #x axis
    c2 = np.cos(rlat_axis) * np.sin(rlon_axis) #y axis
    c3 = np.sin(rlat_axis)          #z axis


    x = np.cos(rlat) * np.cos(rlon)  # x point
    y = np.cos(rlat) * np.sin(rlon)  # y point
    z = np.sin(rlat)  # z point

    xp = x * np.cos(rangle) + (1. - np.cos(rangle)) * (c1 * c1 * x + c1 * c2* y + c1* c3 * z) + (c2 * z - c3 * y) * np.sin(rangle)
    yp = y * np.cos(rangle) + (1. - np.cos(rangle)) * (c2 * c1 * x + c2 * c2 *y + c2 * c3* z) + (c3 * x - c1 * z) * np.sin(rangle)
    zp = z * np.cos(rangle) + (1. - np.cos(rangle)) * (c3 * c1 * x + c3 * c2* y + c3 * c3* z) + (c1 * y - c2 * x) * np.sin(rangle)
    print(x,y,z)
    print(xp,yp,zp)
    lat_p = np.arcsin(zp)
    lon_p = np.arcsin(yp/np.cos(lat_p))
    return lat_p/pi180,lon_p/pi180

def nearest_lists(x,y,xp,yp):
    n_nn=1
    import scipy.spatial as sp
    XY = np.dstack([y, x])[0]
    XYp = np.dstack([yp, xp])[0]
    mytree = sp.cKDTree(XY)
    dist, indx = mytree.query(XYp, n_nn)
    #I = np.nonzero(np.isnan(lon))
    #indx[I] = 0
    return [indx, dist]

def calculate_haversine_distance(lon1, lat1, lon2, lat2):
    """
    Estimation of geographical distance using the Haversine function.

    Input can be single values or 1D arrays of locations. This does NOT create a
        distance matrix but outputs another 1D array.
    This works for either location vectors of equal length OR a single location
        and an arbitrary length location vector.

    Args:
        lon1 (Any): Angles in degrees.
        lat1 (Any): Angles in degrees.
        lon2 (Any): Angles in degrees.
        lat2 (Any): Angles in degrees.

    Returns:
        float: Haversine distance between points.
    """

    # Convert to radians for calculations
    lon1 = np.deg2rad(lon1)
    lat1 = np.deg2rad(lat1)
    lon2 = np.deg2rad(lon2)
    lat2 = np.deg2rad(lat2)

    # Latitude and longitude differences
    dlat = (lat2 - lat1) / 2
    dlon = (lon2 - lon1) / 2

    # Haversine function.
    distance = np.sin(dlat) ** 2 + np.cos(lat1) * np.cos(lat2) * np.sin(dlon) ** 2
    distance = 2 * 6371.007176 * np.arcsin(np.sqrt(distance))

    return distance

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

    def classify (self,shelfbreak=200,ocean_margin_distance=100):
        bathy=self.dataset['bathymetry'].values
        classification=np.zeros(bathy.shape)

        classification[bathy<shelfbreak]=2
        classification[np.isnan(bathy)]=1
        #find shelf break
        shelf_break=np.full(bathy.shape,False)
        shelf_break[1:-1,1:-1]=(
            classification[1:-1,1:-1] == 2 * (
            (classification[0:-2,1:-1]==0) +
            (classification[2:, 1:-1] == 0) +
            (classification[1:-1,0:-2] == 0) +
             (classification[1:-1,2:] == 0)
        ))
        classification[shelf_break] = 3
        #find the closest shelf_break point to each ocean point
        J_ocean,I_ocean=np.where(classification==0)
        Y_ocean = self.dataset['lat'].values[J_ocean]
        X_ocean = self.dataset['lon'].values[I_ocean]

        J_shelf_break,I_shelf_break=np.where(classification==3)
        Y_shelf_break = self.dataset['lat'].values[J_shelf_break]
        X_shelf_break = self.dataset['lon'].values[I_shelf_break]

        I, dist = nearest_lists(Y_shelf_break, X_shelf_break, Y_ocean, X_ocean)
        #find distance between each ocean point and its nearest shelf break point
        distance=calculate_haversine_distance(X_ocean, Y_ocean, X_shelf_break[I], Y_shelf_break[I])
        I_margin=np.where(distance<ocean_margin_distance)
        classification[J_ocean[I_margin],I_ocean[I_margin]]=4
        self.dataset['classification']=xr.DataArray(classification,dims=["y_dim","x_dim"])
class domain:
    def __init__(self, basin,limits,resolution):
        self.limits = limits
        self.resolution = resolution

