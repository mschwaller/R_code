# this code opens up the shapefiles of WRS1 tiles and determines which WRS1 path,row tiles cover known penguin colonies

colony_lonlat <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/lynch_and_schwaller_lonlat.txt", header=FALSE, sep=",", skip=0)
# put the lon,lat coordinates into a matrix
colony_lonlat_matrix <- as.matrix(colony_lonlat)
num_colonies <- length(colony_lonlat_matrix[,1])

library(sp,raster)
library(rgdal)
wrs1_tiles <- readOGR(dsn="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/WRS1_descending_shapefiles", layer="WRS1_descending")
# the coordinates of the path,row tile = wrs1_tiles@polygons[[1]]@Polygons[[1]]@coords for the 1st path,row

result <- point.in.polygon(wrs1_tiles@polygons[[1]]@Polygons[[1]]@labpt[1], wrs1_tiles@polygons[[1]]@Polygons[[1]]@labpt[2], 
                 wrs1_tiles@polygons[[1]]@Polygons[[1]]@coords[,1],wrs1_tiles@polygons[[1]]@Polygons[[1]]@coords[,2])

# print(result)

cntr = 0
path_row_matrix <- matrix(nrow=1, ncol=2)
new_row <- matrix(nrow=1, ncol=2)
for (jj in 1:num_colonies) {
  colony_lat <- colony_lonlat_matrix[jj,2]
  colony_lon <- colony_lonlat_matrix[jj,1]
  for (ii in 1:31508) {
    if (min(wrs1_tiles@polygons[[ii]]@Polygons[[1]]@coords[,2]) > -57.0 | 
        max(wrs1_tiles@polygons[[ii]]@Polygons[[1]]@coords[,2]) < -77.6 ) {next} # skip path,row boxes that are obviously out of bounds
    result <- point.in.polygon(colony_lon, colony_lat, 
                               wrs1_tiles@polygons[[ii]]@Polygons[[1]]@coords[,1],wrs1_tiles@polygons[[ii]]@Polygons[[1]]@coords[,2])
    if (result == 1) {
      cntr = cntr + 1 # ctr starts at 0
      path_id <- wrs1_tiles@data[[1]][ii] # path_id and row_id are R factors!
      row_id  <- wrs1_tiles@data[[2]][ii] # need to convert them into integers as below
      path_row_matrix[cntr,1] <- as.integer(levels(path_id)[path_id])
      path_row_matrix[cntr,2] <- as.integer(levels(row_id)[row_id])
      path_row_matrix <- rbind(path_row_matrix, new_row) # add a new row to the path,row matrix
    } # if statement
  } ## ii loop through all tiles
} ## jj loop through all colonies

path_row_matrix <- head(path_row_matrix, cntr) # pick all but the last row
unique_path_row_matrix <- path_row_matrix[!duplicated(path_row_matrix),] # pick all rows that are NOT duplicated

write.table(unique_path_row_matrix, file="/Users/mschwall/Desktop/wrs1_coords_v1.txt", row.names=FALSE, col.names=FALSE, sep=",")

print(cntr - 1)