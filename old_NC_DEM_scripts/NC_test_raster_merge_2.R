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
  
nc_image_1 <- aggregate(raster(source_file_n35[1]), fact=10)
crs(nc_image_1) <- lat_lon_projection
print("read & aggregated 1st raster")
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
plot(nc_image_1, add=TRUE)

for (ii in 2:num_files) {
    print(ii)
    print(source_file_n35[ii])
    nc_image_2 <- aggregate(raster(source_file_n35[ii]), fact=10)
    crs(nc_image_2) <- lat_lon_projection
    print('merging, then plotting')
    merge_image <- merge(nc_image_1, nc_image_2)
    plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))
    plot(merge_image, add=TRUE)
    nc_image_1 <- nc_image_2
    rm(nc_image_2)
  }
  
box()
axis(1)
axis(2)

print("writing raster to geotif")
writeRaster(merge_image, filename=destination_file, format="GTiff", overwrite=TRUE)
