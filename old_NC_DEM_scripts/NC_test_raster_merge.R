print("reading NC national map rasters and merging them in test mode")

lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
destination_file <- "/Users/mschwall/Desktop/impervious/NC_DEM_test_reduced_resolution.tif"
source_file_img <- c("/Users/mschwall/Desktop/impervious/national_map_NC/n35w079/imgn35w079_13.img",
                     "/Users/mschwall/Desktop/impervious/national_map_NC/n35w080/imgn35w080_13.img")
      
xbounds <- c(-84,-84,-75,-75)
ybounds <- c(33,38,33,38)
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))

num_files <- length(source_file_img)
  
  nc_image_1 <- aggregate(raster(source_file_img[1]), fact=3)
  print("read & aggregated 1st raster")
  nc_image_2 <- aggregate(raster(source_file_img[2]), fact=3)
  print("read & aggregated second raster")
  crs(nc_image_1) <- lat_lon_projection
  crs(nc_image_2) <- lat_lon_projection
  print('merging, then plotting')
  merge_image <- merge(nc_image_1, nc_image_2)
  plot(merge_image, add=TRUE)

box()
axis(1)
axis(2)

print("writing raster to geotif")
writeRaster(merge_image, filename=destination_file, format="GTiff", overwrite=TRUE)
