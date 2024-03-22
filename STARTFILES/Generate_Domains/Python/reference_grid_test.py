import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
import gcoms1k

bathyname="C:/Users/jholt/OneDrive - NOC/Documents/Projects/ACCORD/GEBCO_2014/GEBCO_2014_2D.nc"
a=gcoms1k.gcoms1k(bathyname)
limits=[40,60,-12,12]
a.basin(limits,10)
a.basin_bathy
plt.pcolormesh(a.basin_bathy.bathymetry[:,:])