
# this script plots the outlines of REMA tiles in the vicinity of Possession Island
# it also prints the url for the tile that covers Possession Island 

# configurable parameters
p_title <- "Possession Island"
my_lat <- -71.952  # latitude and longitude of the point of interest
my_lon <- 171.0897

p_title <- "Cape Adare"
my_lat <- -71.3  # latitude and longitude of the point of interest
my_lon <- 170.2

p_title <- "Cape Bird North"
my_lat <- -77.27  # latitude and longitude of the point of interest
my_lon <- 166.45

p_title <- "Cape Crozier"
my_lat <- -77.45  # latitude and longitude of the point of interest
my_lon <- 169.25

lat_min <- round(my_lat) - 3.0
lat_max <- round(my_lat) + 3.0
lon_min <- round(my_lon) - 10.0
lon_max <- round(my_lon) + 10.0

library(sp,raster)
library(rgdal)
rema_tiles <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/REMA_analysis/REMA_Tile_Index_Rel1", layer="REMA_Tile_Index_Rel1")
lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
rema_tiles_latlon <- spTransform(rema_tiles, lat_lon_projection) # transform the native projection of the rema_tile shape file into geographic lat,lon

summary(rema_tiles_latlon)

num_tiles = length(rema_tiles_latlon@polygons) # count the number of tiles that cover all of Antarctica
tile_center_coordinates <- matrix(nrow=num_tiles, ncol=2) # a matrix of the tile center coordinates
for (ii in 1:num_tiles) tile_center_coordinates[ii,] <- rema_tiles_latlon@polygons[[ii]]@Polygons[[1]]@labpt # fill the matrix with each tile's center coordinates

# get a vector map of the Antarctic coastline and islands
antarctic_coast_line <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/REMA_analysis/Antarctic_coastline_high_res_line", layer="Coastline_high_res_line")
summary(antarctic_coast_line)

# plot the Antarctic coastline using the geographic lat,lon projection in the region around Possession Island
library(maptools)
data("wrld_simpl")
antarctica <-  wrld_simpl[wrld_simpl$NAME == "Antarctica", ]
antarctica.latlon_projection <- spTransform(antarctica, lat_lon_projection)
plot(antarctica.latlon_projection)
plot(antarctica.latlon_projection, xlim=c(lon_min, lon_max), ylim=c(lat_min, lat_max), xlab="longitude degrees", ylab="latitude degrees", main=p_title)

# plot the outline of the REMA tiles
points(my_lon, my_lat, pch=19, col="red") # but first plot a point at the location of Possession Island
plot(rema_tiles_latlon, add=TRUE) 
# text(tile_center_coordinates[,1], tile_center_coordinates[,2], tile_names, col="black", cex=0.7)
text(tile_center_coordinates[,1], tile_center_coordinates[,2], rema_tiles_latlon@data[[1]], col="black", cex=0.7)
box()
axis(1)
axis(2)

# by looking at the map it is apparent that the tile 38_21 covers Possession Is
# to find the url for this tile
url_array <- levels(rema_tiles$fileurl) # levels turns the Factor rema_tiles$fileurl into a vector of urls
possession_url <- url_array[grep("38_21", url_array)]
print(paste("REMA tile covering ", p_title,": ", possession_url, sep=""))
print("DONE!")

