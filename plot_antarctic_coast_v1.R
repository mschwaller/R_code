library(maps)
library(mapdata)
library(maptools)
library(sp,raster)
library(rgdal)

rema_tiles <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/REMA_analysis/REMA_Tile_Index_Rel1", layer="REMA_Tile_Index_Rel1")
summary(rema_tiles)
rema_proj <- "+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

antarctic_coast_line <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/REMA_analysis/Antarctic_coastline_high_res_polygon", layer="Coastline_high_res_polygon")
summary(antarctic_coast_line)

plot(rema_proj)
plot(antarctic_coast_line, axes=TRUE,  xlim=c(200000,400000),ylim=c(-2500000.5, -1900000.0)) 
plot(rema_tiles, add=TRUE)
box()