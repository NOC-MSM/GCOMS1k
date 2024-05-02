import xarray as xr
import numpy as np
import matplotlib.pyplot as plt
import gcoms1k
bathyname="C:/Users/jholt/OneDrive - NOC/Documents/Projects/ACCORD/GEBCO_2014/GEBCO_2014_2D.nc"

limits=[40,65,-20,12]
a=gcoms1k.basin(bathyname,limits,10)
plt.pcolormesh(a.dataset.bathymetry[:,:])
plt.show()
a.classify()
plt.pcolormesh(a.dataset.classification[:,:])
plt.show()