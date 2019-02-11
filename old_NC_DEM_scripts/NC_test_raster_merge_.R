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

xbounds <- c(-84,-84,-75,-75)
ybounds <- c(33,38,33,38)

num_files <- length(source_file_n35)
  
base_image <- aggregate(raster(source_file_n35[1]), fact=10)
crs(base_image) <- lat_lon_projection
print("read & aggregated 1st raster")
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(base_image, add=TRUE)

for (ii in 2:num_files) {
    print(ii)
    print(source_file_n35[ii])
    add_image <- aggregate(raster(source_file_n35[ii]), fact=10)
    crs(add_image) <- lat_lon_projection
    print('merging, then plotting')
    base_image <- merge(base_image, add_image)
    plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
    plot(base_image, add=TRUE)
  }
  
rm(add_image)

print("writing raster to geotif")
writeRaster(base_image, filename=destination_file, format="GTiff", overwrite=TRUE)
