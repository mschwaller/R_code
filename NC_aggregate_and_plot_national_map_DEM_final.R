print("reading NC national map rasters and merging them in test mode")

lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
destination_file <- "/Users/mschwall/Desktop/impervious/NC_DEM_test_reduced_resolution.tif"
source_file_img <- c("/Users/mschwall/Desktop/impervious/national_map_NC/n35w076/grdn35w076_13/w001001.adf",
                     "/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n35w077_ArcGrid/grdn35w077_13/w001001.adf")

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

xbounds <- c(-84,-84,-75,-75)
ybounds <- c(33,38,33,38)

num_files <- length(source_file_n35)

print("doing N35 rasters") # aggregate all the rasters along longitude N35
base_image_35 <- aggregate(raster(source_file_n35[1]), fact=10)
crs(base_image_35) <- lat_lon_projection
print("read & aggregated 1st raster")
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(base_image_35, add=TRUE)
for (ii in 2:num_files) {
  print(ii)
  print(source_file_n35[ii])
  add_image <- aggregate(raster(source_file_n35[ii]), fact=10)
  crs(add_image) <- lat_lon_projection
  print('merging, then plotting')
  base_image_35 <- merge(base_image_35, add_image)
  plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
  plot(base_image_35, add=TRUE)
}
rm(add_image)

print("doing N36 rasters") # aggregate all the rasters along longitude N3
base_image_36 <- aggregate(raster(source_file_n36[1]), fact=10)
crs(base_image_36) <- lat_lon_projection
print("read & aggregated 1st raster")
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(base_image_36, add=TRUE)
for (ii in 2:num_files) {
  print(ii)
  print(source_file_n36[ii])
  add_image <- aggregate(raster(source_file_n36[ii]), fact=10)
  crs(add_image) <- lat_lon_projection
  print('merging, then plotting')
  base_image_36 <- merge(base_image_36, add_image)
  plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
  plot(base_image_36, add=TRUE)
}
rm(add_image)

merge_image <- merge(base_image_36, base_image_35)
rm(base_image_35, base_image_36)
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(merge_image, add=TRUE)

print("doing N37 rasters") # aggregate all the rasters along longitude N3
base_image_37 <- aggregate(raster(source_file_n37[1]), fact=10)
crs(base_image_37) <- lat_lon_projection
print("read & aggregated 1st raster")
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(base_image_37, add=TRUE)
for (ii in 2:num_files) {
  print(ii)
  print(source_file_n37[ii])
  add_image <- aggregate(raster(source_file_n37[ii]), fact=10)
  crs(add_image) <- lat_lon_projection
  print('merging, then plotting')
  base_image_37 <- merge(base_image_37, add_image)
  plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
  plot(base_image_37, add=TRUE)
}
rm(add_image)

merge_image <- merge(base_image_37, merge_image)
rm(base_image_37)
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(merge_image, add=TRUE)

print("writing raster to geotif")
writeRaster(merge_image, filename=destination_file, format="GTiff", overwrite=TRUE)
