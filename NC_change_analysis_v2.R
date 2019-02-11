
print("starting!")
library(stringr)
library(sp)
library(raster)
library(rgdal)
shp_filepath <- "/Users/mschwall/Desktop/impervious/USGS Stream Stats Basins"
shp_dirs <- list.dirs(path="/Users/mschwall/Desktop/impervious/USGS Stream Stats Basins", recursive = FALSE, full.names = FALSE)
num_dirs <- length(shp_dirs)
paths_array <- vector(mode="character", length=num_dirs)
for (ii in 1:num_dirs) {
  name_no_SS <- str_sub(shp_dirs[ii], start=4, end=-1)
  a_dir <- paste(shp_filepath, "/", shp_dirs[ii], "/", name_no_SS, "/Layers",  sep="")
  print(a_dir)
  paths_array[ii] <- a_dir
}

print("reading first shapefile")
lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
nc_projection <- CRS("+init=epsg:2264")
basin <- readOGR(dsn=paths_array[1], layer="GlobalWatershed")
basin_latlon <- spTransform(basin, nc_projection) # convert the nhgis0042_shapefile_tl2016_us_county_2016 projection to geographic lat,lon
plot(basin_latlon, xlim=c(1696873, 3175545), ylim=c(92518, 1024616))
#text(tile_center_coordinates[,1], tile_center_coordinates[,2], tile_names, col="black", cex=0.7)
box()
axis(1)
axis(2)

#print("reading img raster")
#source_dir <- "/Users/mschwall/Desktop/impervious/nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10"
#source_file_img <- paste(source_dir, "nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10.img", sep="")
#nc_image <- raster(source_file_img)
#plot(nc_image, add=TRUE)

#for (ij in 2:num_dirs) {
#  print("starting iteration")
#  print(ij)
#  print(paths_array[ij])
#  basin <- readOGR(dsn=paths_array[ij], layer="GlobalWatershed")
#  basin_latlon <- spTransform(basin, lat_lon_projection) # convert the original basin projection to geographic lat,lon
#  print(basin_latlon)
#  plot(basin_latlon, add=TRUE)
#}