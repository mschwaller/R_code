# this script determines which Adelie colonies fall within the bounds of 
# a given set of Landsat MSS scenes

library(sp,raster)
library(rgdal)
library(Matrix)

# read in the scene boundaries from Landsats 1,2 & 3
mss_123_hits_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_R_all_cols_L123.txt", 
                           header=TRUE, sep=",", skip=0) 
polygon_x_matrix <- cbind(mss_123_hits_frame$upperRightCornerLongitude, mss_123_hits_frame$lowerRightCornerLongitude, mss_123_hits_frame$lowerLeftCornerLongitude, mss_123_hits_frame$upperLeftCornerLongitude,
                          mss_123_hits_frame$upperRightCornerLongitude) # add last column to make this a polygon
polygon_y_matrix <- cbind(mss_123_hits_frame$upperRightCornerLatitude, mss_123_hits_frame$lowerRightCornerLatitude, mss_123_hits_frame$lowerLeftCornerLatitude, mss_123_hits_frame$upperLeftCornerLatitude,
                          mss_123_hits_frame$upperRightCornerLatitude) # do the same here

# read in the scene boundaries from Landsats 4 & 5 (which have a slightly different set of metadata)
#mss_45_hits_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_R_all_cols_L45.txt", 
#                           header=TRUE, sep=",", skip=0) 
#polygon_x_matrix <- rbind2(polygon_x_matrix, cbind(mss_45_hits_frame$upperRightCornerLongitude, mss_45_hits_frame$lowerRightCornerLongitude, mss_45_hits_frame$lowerLeftCornerLongitude, mss_45_hits_frame$upperLeftCornerLongitude,
#                          mss_45_hits_frame$upperRightCornerLongitude)) # add the L4,5 info to the end of the L123 matrix
#polygon_y_matrix <- rbind2(polygon_y_matrix, cbind(mss_45_hits_frame$upperRightCornerLatitude, mss_45_hits_frame$lowerRightCornerLatitude, mss_45_hits_frame$lowerLeftCornerLatitude, mss_45_hits_frame$upperLeftCornerLatitude,
#                          mss_45_hits_frame$upperRightCornerLatitude)) # do the same here

# read in the Adelie colony counts
adelie_lat_lon_count_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/adelie_most_recent_count_lat_lon_siteID.txt", 
                              header=TRUE, sep=",", skip=0) 
# set any NA in the population column to 0
adelie_lat_lon_count_frame$population[is.na(adelie_lat_lon_count_frame$population)] <- 0

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
                           # print(as.character(adelie_lat_lon_count_frame$siteID[ic]))
                           IDs_with_imagery <- c(IDs_with_imagery, as.character(adelie_lat_lon_count_frame$siteID[ic]))
                           # print(paste("   ", as.character(adelie_lat_lon_count_frame$longitude[ic]), 
                           #       as.character(adelie_lat_lon_count_frame$latitude[ic])))
                           # print(paste("   ", as.character(polygon_x_matrix[ip,]), 
                           #       as.character(polygon_y_matrix[ip,])))
                         }
      
  }
}

# I checked Earth Explorer and all of these colonies have MSS imagery in the 1970 era
checked_IDs <- c("ADAR","HERO","BEAG","CROZ","POSS","HOPE","RAUE","PAUL","VESS","BRAS","LSAY","MACK","BEAU","PIGE","EDWI")
checked_IDs <- c(checked_IDs, "CHAL", 'COTT', "EDEN","PGEO", "PLAT","SVEN") # ROOK and SCUL have imagery but it is cloudy
IDs_with_imagery <- IDs_with_imagery[2:length(IDs_with_imagery)] # just pull off the colony ID parts
IDs_with_imagery <- c(checked_IDs, IDs_with_imagery)
IDs_with_imagery <- unique(IDs_with_imagery)

total_adelie_population <- sum(adelie_lat_lon_count_frame$population)
total_adelie_population_with_MSS_imagery <- sum(adelie_lat_lon_count_frame$population[adelie_lat_lon_count_frame$siteID %in% unique(IDs_with_imagery)])
fraction_found <- total_adelie_population_with_MSS_imagery / total_adelie_population

print(paste("total adelie population", total_adelie_population, sep=" "))
print(paste("total adelie population with MSS coverage", total_adelie_population_with_MSS_imagery, sep=" "))
print(paste("fraction of adelie population covered by MSS imagery", total_adelie_population_with_MSS_imagery/total_adelie_population, sep=" "))

has_imagery_test <- adelie_lat_lon_count_frame$siteID %in% unique(IDs_with_imagery)
site_GT_10000_test <- adelie_lat_lon_count_frame$population > 10000
total_adelie_population_GT_10000_with_MSS_imagery <- sum(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_10000_test])
num_adelie_colonies_population_GT_10000_with_MSS_imagery <- length(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_10000_test])
total_adelie_colonies_population_GT_10000 <- length(which((adelie_lat_lon_count_frame$population > 10000) == TRUE))
print(paste("total adelie population with MSS coverage & population > 10,000 nests", total_adelie_population_GT_10000_with_MSS_imagery, sep=" "))
print(paste("fraction of adelie colonies with population > 10,000 nest & covered by MSS imagery", total_adelie_population_GT_10000_with_MSS_imagery/total_adelie_population, sep=" "))
print(paste("number of adelie colonies with MSS coverage & population > 10,000 nests", num_adelie_colonies_population_GT_10000_with_MSS_imagery, sep=" "))
print(paste("total number of adelie colonies with population > 10,000 nests", total_adelie_colonies_population_GT_10000, sep=" "))

site_GT_40000_test <- adelie_lat_lon_count_frame$population > 40000
total_adelie_population_GT_40000_with_MSS_imagery <- sum(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_40000_test])
num_adelie_colonies_population_GT_40000_with_MSS_imagery <- length(adelie_lat_lon_count_frame$population[has_imagery_test & site_GT_40000_test])
total_adelie_colonies_population_GT_40000 <- length(which((adelie_lat_lon_count_frame$population > 40000) == TRUE))
print(paste("total adelie population with MSS coverage & population > 40,000 nests", total_adelie_population_GT_40000_with_MSS_imagery, sep=" "))
print(paste("fraction of adelie colonies with population > 40,000 nest & covered by MSS imagery", total_adelie_population_GT_40000_with_MSS_imagery/total_adelie_population, sep=" "))
print(paste("number of adelie colonies with MSS coverage & population > 40,000 nests", num_adelie_colonies_population_GT_40000_with_MSS_imagery, sep=" "))
print(paste("total number of adelie colonies with population > 40,000 nests", total_adelie_colonies_population_GT_40000, sep=" "))



