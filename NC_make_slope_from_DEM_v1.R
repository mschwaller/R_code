# first, add some libraries
library(sp)
library(raster)
library(rgdal)
library(maptools)

slope_outfile = "/Users/mschwall/Desktop/impervious/NC_slope_reduced_resolution"

nc_dem <- raster("/Users/mschwall/Desktop/impervious/NC_DEM_test_reduced_resolution.tif")
# nd_dem <- readGDAL("/Users/mschwall/Desktop/impervious/NC_DEM_test_reduced_resolution.tif")
# plot(nc_dem) # plot the DEM

nc_slope <- terrain(nc_dem, opt="slope", unit="degrees", neighbors=4, filename=slope_outfile)
plot(nc_slope) # plot the slope in degrees