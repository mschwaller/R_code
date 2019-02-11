# this script finds all of the scenes with MSS and TM data that fall over known colonies

# configurable parameters
min_sun_elevation_deg <- 15      # in degrees
max_cloud_cover_land_pct <- 20   # in percent

# ingest the set of WRS2 path,row coordinates that cover known Adelie colonies
wrs2_path_row_coord_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/wrs2_coords_over_colonies_v1.txt", 
                                      header=FALSE, sep=",", skip=0, col.names=c("path", "row"))

# ingest the Landsat MSS/TM metadata 
# these are the coincident MSS/TM images
mss_meta_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/L45_TM_coincident_with_MSS_has_polygons_v1.txt", 
                           header=TRUE, sep=",", skip=0) # skip the metadata columns where meta_picker == NULL

# find the indices of all LM04 and LM05 (WSR-2) that meet various selection criteria
wrs2_path_hits <- is.element(mss_meta_frame$path, unique(wrs2_path_row_coord_frame$path)) # vector of TRUE where there is a path hit & FALSE where there isn't
wrs2_row_hits  <- is.element(mss_meta_frame$xrow,  unique(wrs2_path_row_coord_frame$row)) # vector of TRUE where there is a row hit & FALSE where there isn't
Landsat_45_index <- which((mss_meta_frame$sunElevation >= min_sun_elevation_deg)  
                          & ((mss_meta_frame$CLOUD_COVER_LAND  < max_cloud_cover_land_pct))
                          & (wrs2_path_hits & wrs2_row_hits)) 

# then subset the mss_meta_frame to meet the selection criteria
mss_meta_frame <- mss_meta_frame[Landsat_45_index,]

polygon_x_matrix <- cbind(mss_meta_frame$upperRightCornerLongitude, mss_meta_frame$lowerRightCornerLongitude, mss_meta_frame$lowerLeftCornerLongitude, mss_meta_frame$upperLeftCornerLongitude,
                          mss_meta_frame$upperRightCornerLongitude) # add last column to make this a polygon
polygon_y_matrix <- cbind(mss_meta_frame$upperRightCornerLatitude, mss_meta_frame$lowerRightCornerLatitude, mss_meta_frame$lowerLeftCornerLatitude, mss_meta_frame$upperLeftCornerLatitude,
                          mss_meta_frame$upperRightCornerLatitude) # do the same here


# read in the Adelie colony counts
adelie_lat_lon_count_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/adelie_most_recent_count_lat_lon_siteID.txt", 
                                       header=TRUE, sep=",", skip=0) 
# set any NA in the population column to 0
adelie_lat_lon_count_frame$population[is.na(adelie_lat_lon_count_frame$population)] <- 0
site_GT_40000_test <- adelie_lat_lon_count_frame$population > 40000

n_sites <- length(adelie_lat_lon_count_frame$siteID)
n_pols  <- length(polygon_x_matrix[,1]) 
IDs_with_imagery <- "ID"
for (ic in 1:n_sites) {
  for (ip in 1:n_pols) {
    # skip cases where the scene boundary crosses the meridian becasue the polygon has + and - longitude values
    if ((! all(polygon_x_matrix[ip,] >0)) & (! all(polygon_x_matrix[ip,] < 0))) 
    { next }
    if (point.in.polygon(adelie_lat_lon_count_frame$longitude[ic], adelie_lat_lon_count_frame$latitude[ic], 
                         polygon_x_matrix[ip,], polygon_y_matrix[ip,])) {
      #print(as.character(adelie_lat_lon_count_frame$siteID[ic]))
      IDs_with_imagery <- c(IDs_with_imagery, as.character(adelie_lat_lon_count_frame$siteID[ic]))
      # print(paste("   ", as.character(adelie_lat_lon_count_frame$longitude[ic]), 
      #       as.character(adelie_lat_lon_count_frame$latitude[ic])))
      # print(paste("   ", as.character(polygon_x_matrix[ip,]), 
      #       as.character(polygon_y_matrix[ip,])))
    }
    
  }
}

IDs_with_imagery <- IDs_with_imagery[2:length(IDs_with_imagery)] # just pull off the colony ID parts
unique_IDs_with_imagery <- unique(IDs_with_imagery)

has_imagery_test <- adelie_lat_lon_count_frame$siteID %in% IDs_with_imagery
site_GT_40000_test <- adelie_lat_lon_count_frame$population > 40000
num_adelie_colonies_population_GT_40000_with_MSS_imagery <- length(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_40000_test])
total_adelie_colonies_population_GT_40000 <- length(which((adelie_lat_lon_count_frame$population > 40000) == TRUE))
print(paste("number of adelie colonies with MSS+TM coverage & population > 40,000 nests", num_adelie_colonies_population_GT_40000_with_MSS_imagery, sep=" "))
print(as.character(adelie_lat_lon_count_frame$siteID[has_imagery_test & site_GT_40000_test]))
print(paste("total number of adelie colonies with population > 40,000 nests", total_adelie_colonies_population_GT_40000, sep=" "))

site_GT_20000_test <- adelie_lat_lon_count_frame$population > 20000
num_adelie_colonies_population_GT_20000_with_MSS_imagery <- length(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_20000_test])
total_adelie_colonies_population_GT_20000 <- length(which((adelie_lat_lon_count_frame$population > 20000) == TRUE))
print(paste("number of adelie colonies with MSS+TM coverage & population > 20,000 nests", num_adelie_colonies_population_GT_20000_with_MSS_imagery, sep=" "))
print(as.character(adelie_lat_lon_count_frame$siteID[has_imagery_test & site_GT_20000_test]))
print(paste("total number of adelie colonies with population > 20,000 nests", total_adelie_colonies_population_GT_20000, sep=" "))

print(" ")
print(paste("total number of Adelie colonies with MSS+TM imagery", length(IDs_with_imagery)), sep=" ")
print(paste("total number of unique Adelie colonies with MSS+TM imagery", length(unique_IDs_with_imagery)), sep=" ")

print(" ")
print(paste("number coincident MSS & TM scenes over Adelie colonies with sun_elevation>15 deg & cloud_cover<20 pct", length(Landsat_45_index), sep=" "))
print(paste("total number coincident MSS & TM scenes with sun_elevation>15 deg & cloud_cover<20 pct", length(mss_meta_frame$path), sep=" "))
