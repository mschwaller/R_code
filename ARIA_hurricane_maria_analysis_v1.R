# this script plots the PR counties and will eventually add the ARIA dammage points for Hurriacane Maria

# first, add some libraries
library(sp)
library(raster)
library(rgdal)
library(maptools)

# open the shapefile of county boundaries
PR_counties <- readOGR(dsn="/Users/mschwall/Desktop/hurricane_maria/nhgis0042_shapefile_tl2016_us_county_2016", layer="US_county_2016") # ingest the shapefile
lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
PR_counties_latlon <- spTransform(PR_counties, lat_lon_projection) # convert the nhgis0042_shapefile_tl2016_us_county_2016 projection to geographic lat,lon
plot(PR_counties_latlon, xlim=c(-67.5, -64.5), ylim=c(17.5, 18.5 ), xlab="longitude degrees", ylab="latitude degrees")
box() # put a box around the plot
axis(1) # and add the axis ticks
axis(2)

# now open one of the geotiffs (there are 10 for the eastern part & 9 for the western part)
tiff_name <- "/Users/mschwall/Desktop/hurricane_maria/20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s2_04_c0.7g1_T1H0B0U1_dpm.tif"
# GDALinfo(tiff_name) # get some info on the tiff
PR_tiff1 <- raster(tiff_name, band=1) # open the tiff as a raster
crs(PR_tiff1) <- lat_lon_projection # use the same projections for the raster
hot_spot_index <- which(PR_tiff1[,]<255) # find the index values of the hurricane Maria hot spots
hot_spot_values <- PR_tiff1[which(PR_tiff1[,]<255)] # find the band-1 values of hot spots
print("hot spot index")
print(hot_spot_index)
print("hot spot values")
print(hot_spot_values)

PR_data <- rasterToPoints(PR_tiff1) # convert the raster to a lon,lat,value matrix
points(PR_data[which(PR_data[,3] < 255),1], PR_data[which(PR_data[,3] < 255),2], pch=19, col="red") # plot the location of the points with values < 255