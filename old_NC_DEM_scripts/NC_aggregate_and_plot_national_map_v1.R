# this proc reads in USGS National Map DEMs of North Carolina as 9x3=27 separate tiles
# then subsamples the tiles to a lower resolution and merges the tiles to create a complete
# 3D map of North Carolina


# first, add some libraries
library(sp)
library(raster)

print("reading NC national map raster")

lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
destination_file <- "/Users/mschwall/Desktop/impervious/NC_DEM_reduced_resolution.tif"
ag_fac = 10 # do 1-in-10 subsampling of the raster

# north carolina DEM source files along 35 degrees north latitude
source_file_n35 <- c("/Users/mschwall/Desktop/impervious/national_map_NC/n35w076/grdn35w076_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n35w077_ArcGrid/grdn35w077_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n35w078_ArcGrid/grdn35w078_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w079/imgn35w079_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w080/imgn35w080_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w081/imgn35w081_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w082/grdn35w082_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n35w083_ArcGrid/grdn35w083_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w084/grdn35w084_13/w001001.adf")

source_file_n36 <- c("/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w076_ArcGrid/grdn36w076_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w077_ArcGrid/grdn36w077_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w078_ArcGrid/grdn36w078_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n36w079/grdn36w079_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n36w080/imgn36w080_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n36w081/grdn36w081_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n36w082/grdn36w082_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w083_ArcGrid/grdn36w083_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w084_ArcGrid/grdn36w084_13/w001001.adf")

source_file_n37 <- c(  "/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w076_ArcGrid/grdn37w076_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w077_ArcGrid/grdn37w077_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w078_ArcGrid/grdn37w078_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n37w079/grdn37w079_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n37w080/grdn37w080_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n37w081/imgn37w081_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w082_ArcGrid/grdn37w082_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w083_ArcGrid/grdn37w083_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w084_ArcGrid/grdn37w084_13/w001001.adf")


xbounds <- c(-85,-85,-75,-75)
ybounds <- c(33,38,33,38)

num_files <- length(source_file_n37)
# num_files <- 2 # for testing

print("doing N35 rasters") # aggregate all the rasters along longitude N35
base_35_raster <- aggregate(raster(source_file_n35[1]), fac=ag_fac)
crs(base_35_raster) <- lat_lon_projection
plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
plot(base_35_raster, add=TRUE)

for (ii in 2:num_files) {
  print(ii)
  print(source_file_n35[ii])
  add_raster <- aggregate(raster(source_file_n35[ii]), fac=ag_fac)
  crs(add_raster) <- lat_lon_projection
  big_35_raster <- merge(add_raster, base_35_raster)
  plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
  plot(big_35_raster, ADD=TRUE)
  base_35_raster <- add_raster
  rm(add_raster)
}

print("doing N36 rasters")  # aggregate all the rasters along longitude N36
base_36_raster <- aggregate(raster(source_file_n36[1]), fac=ag_fac)
crs(base_36_raster) <- lat_lon_projection
plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
plot(base_36_raster, add=TRUE)

for (ii in 2:num_files) {
  print(ii)
  print(source_file_n36[ii])
  add_raster <- aggregate(raster(source_file_n36[ii]), fac=ag_fac)
  crs(add_raster) <- lat_lon_projection
  base_36_raster <- merge(base_36_raster, add_raster)
  plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
  plot(base_36_raster, add=TRUE)
}

full_raster <- merge(base_35_raster, base_36_raster) # merge the 2 base rasters
rm(base_35_raster, base_36_raster) # then remove the base rasters

print("doing N37 rasters")  # aggregate all the rasters along longitude N37
base_37_raster <- aggregate(raster(source_file_n37[1]), fac=ag_fac)
crs(base_37_raster) <- lat_lon_projection
plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
plot(base_37_raster, add=TRUE)

for (ii in 2:num_files) {
  print(ii)
  print(source_file_n37[ii])
  add_raster <- aggregate(raster(source_file_n37[ii]), fac=ag_fac)
  crs(add_raster) <- lat_lon_projection
  base_37_raster <- merge(base_37_raster, add_raster)
  plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
  plot(base_37_raster, add=TRUE)
}

print("now plotting FINAL raster")
full_raster <- merge(full_raster, base_37_raster)
rm(base_37_raster)
plot(xbounds, ybounds, xlim=c(-85, -75), ylim=c(33, 38))
plot(full_raster, add=TRUE)

box() # draw the axes & a box around the plot
axis(1)
axis(2)

print("writing raster to geotif") # save the full DEM of North Carolina
writeRaster(full_raster, filename=destination_file, format="GTiff", overwrite=TRUE)

