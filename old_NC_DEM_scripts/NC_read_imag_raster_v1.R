
library(raster)
lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
nc_projection <- CRS("+init=epsg:2264")


print("reading img raster")
source_dir <- "/Users/mschwall/Desktop/impervious/nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10/"
source_file_img <- paste(source_dir, "nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10.img", sep="")
nc_image <- raster(source_file_img)
crs(nc_image) <- lat_lon_projection
#crs(nc_image) <- nc_projection # use the same projections for the raster
#plot(nc_image, xlim=c(1696873, 3175545), ylim=c(92518, 1024616))
#text(tile_center_coordinates[,1], tile_center_coordinates[,2], tile_names, col="black", cex=0.7)
#box()
#axis(1)
#axis(2)
#plot(nc_image)

#destination_file_tif <- "/Users/mschwall/Desktop/impervious/nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10.tif"
#writeRaster(nc_image, destination_file_tif, format = "GTiff", overwrite=TRUE)

print(nc_image@data@attributes)
print(nc_image@data@attributes[[1]][12])
