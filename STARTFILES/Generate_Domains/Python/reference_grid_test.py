import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
import gcoms1k

bathyname="C:/Users/jholt/OneDrive - NOC/Documents/Projects/ACCORD/GEBCO_2014/GEBCO_2014_2D.nc"

limits=[40,60,-12,12]
a=gcoms1k.basin(bathyname,limits,10)
plt.pcolormesh(a.dataset.bathymetry[:,:])