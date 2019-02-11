library(sp,raster)
library(rgdal)
rema_tiles <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/REMA_analysis/REMA_Tile_Index_Rel1", layer="REMA_Tile_Index_Rel1")
summary(rema_tiles)
num_tiles = length(rema_tiles@polygons)
tile_center_coordinates <- matrix(nrow=num_tiles, ncol=2) # a matrix of the tile center coordinates
tile_names <- levels(rema_tiles@data[[1]])
for (ii in 1:num_tiles) tile_center_coordinates[ii,] <- rema_tiles@polygons[[ii]]@Polygons[[1]]@labpt # fill the matrix with center coordinates

rema_proj <- "+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
antarctic_coast_line <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/REMA_analysis/Antarctic_coastline_high_res_line", layer="Coastline_high_res_line")
summary(antarctic_coast_line)
#
library(maptools)
data("wrld_simpl")
antarctica <-  wrld_simpl[wrld_simpl$NAME == "Antarctica", ]
antarctica.rema_projection <- spTransform(antarctica, CRS(rema_proj))
plot(antarctica.rema_projection)
plot(antarctica.rema_projection, xlim=c(200000,800000),ylim=c(-2200000, -1800000))
plot(rema_tiles, add=TRUE)
text(tile_center_coordinates[,1], tile_center_coordinates[,2], tile_names, col="black", cex=0.7)
box()
axis(1)
axis(2)

