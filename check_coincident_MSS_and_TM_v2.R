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
                          & ((mss_meta_frame$CLOUD_COVER_LAND  <= max_cloud_cover_land_pct))
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

# create a data frame to hold the site_ID from the adelie_lat_lon_count_frame and the corresponding path, row & sceneID from the mss_meta_frame
site_scene_matchup <- data.frame("IDs_with_imagery"="ID", "path"=0, "row"=0, "sceneID"="xxx", population_test=TRUE, cloud_elevation_test=TRUE, stringsAsFactors=FALSE) # set an initial dummy value


n_sites <- length(adelie_lat_lon_count_frame$siteID)
n_pols  <- length(polygon_x_matrix[,1]) 
for (ic in 1:n_sites) {
  for (ip in 1:n_pols) {
    # skip cases where the scene boundary crosses the meridian becasue the polygon has + and - longitude values
    if ((! all(polygon_x_matrix[ip,] >0)) & (! all(polygon_x_matrix[ip,] < 0))) 
    { next }
    if (point.in.polygon(adelie_lat_lon_count_frame$longitude[ic], adelie_lat_lon_count_frame$latitude[ic], 
                         polygon_x_matrix[ip,], polygon_y_matrix[ip,])) {
      #print(as.character(adelie_lat_lon_count_frame$siteID[ic]))
      pop_test <- (adelie_lat_lon_count_frame$population[ic] >= 40000)
      cloud_ele_test <- (mss_meta_frame$sunElevation[ip] >= min_sun_elevation_deg) & (mss_meta_frame$CLOUD_COVER_LAND[ip]  < max_cloud_cover_land_pct)
      site_scene_matchup <- rbind(site_scene_matchup, 
                            list(adelie_lat_lon_count_frame$siteID[ic], mss_meta_frame$path[ip], mss_meta_frame$xrow[ip], mss_meta_frame$SceneID[ip], pop_test, cloud_ele_test))
    }
    
  }
}

site_scene_matchup <- site_scene_matchup[2:length(site_scene_matchup$IDs_with_imagery),] # just pull off the colony ID parts
unique_IDs_with_imagery <- unique(site_scene_matchup$IDs_with_imagery)

site_GT_20000_test <- adelie_lat_lon_count_frame$population > 20000
num_adelie_colonies_population_GT_20000_with_MSS_imagery <- length(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_20000_test])
total_adelie_colonies_population_GT_20000 <- length(which((adelie_lat_lon_count_frame$population > 20000) == TRUE))
print(paste("number of Adelie colonies with MSS+TM coverage & population > 20,000 nests", num_adelie_colonies_population_GT_20000_with_MSS_imagery, sep=" "))
print(as.character(adelie_lat_lon_count_frame$siteID[has_imagery_test & site_GT_20000_test]))
print(paste("total number of Adelie colonies with population > 20,000 nests", total_adelie_colonies_population_GT_20000, sep=" "))
print("")

has_imagery_test <- adelie_lat_lon_count_frame$siteID %in% site_scene_matchup$IDs_with_imagery
site_GT_40000_test <- adelie_lat_lon_count_frame$population > 40000
print(paste("number of Adelie colonies with population > 40,000 nests", total_adelie_colonies_population_GT_40000, sep=" "))
num_adelie_colonies_population_GT_40000_with_MSS_imagery <- length(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_40000_test])
total_adelie_colonies_population_GT_40000 <- length(which((adelie_lat_lon_count_frame$population > 40000) == TRUE))
print(paste("total of Adelie colonies with MSS+TM coverage & population > 40,000 nests", num_adelie_colonies_population_GT_40000_with_MSS_imagery, sep=" "))
print(as.character(adelie_lat_lon_count_frame$siteID[has_imagery_test & site_GT_40000_test]))
print("scenes over Adelie colonies with a population>40,000 nest, matching MSS+TM coverage, and sun_elevation>15 deg & cloud_cover<20 pct")
print("site_ID, path, row, scene_ID")
good_hits_index <- which(site_scene_matchup$population_test == TRUE)
num_good_hits <- length(good_hits_index)
for (ip in 1:num_good_hits) {
  print(paste(site_scene_matchup$IDs_with_imagery[good_hits_index[ip]], site_scene_matchup$path[good_hits_index[ip]], 
              site_scene_matchup$row[good_hits_index[ip]], site_scene_matchup$sceneID[good_hits_index[ip]], sep=","))
}


print(" ")
print(paste("number coincident MSS & TM scenes with sun_elevation>15 deg & cloud_cover<20 pct (not necessarily over Adelie colonies):", length(site_scene_matchup$IDs_with_imagery), sep=" "))
all_hits <- length(site_scene_matchup$IDs_with_imagery)
for (ip in 1:all_hits) {
  print(paste(ip, site_scene_matchup$IDs_with_imagery[ip], site_scene_matchup$path[ip], 
              site_scene_matchup$row[ip], site_scene_matchup$sceneID[ip], sep=","))
}



