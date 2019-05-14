# read and plot a REMA tile

library(raster)
par(mar=c(5.1, 4.1, 4.1, 2.1))

################################## configurable parameters ###################################
# ADAR
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/10_34_8m_ADAR/10_34_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/ADAR_LC80631102013319/ADAR_LC80631102013319_Dec13h17m14s37y2017"
c_name <- "ADAR"
# CROZ
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/17_33_8m_CROZ/17_33_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/CROZ_LC80521162014309/CROZ_LC80521162014309_Dec13h22m01s15y2017"
c_name <- "CROZ"
# BRDN
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/17_34_8m_BRDN/17_34_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/BRDN_LC80531162013361/BRDN_LC80531162013361_Dec13h22m02s17y2017"
c_name <- "BRDN"

REMA_raster <- raster(REMA_file_path)
L8_raster <- brick(L8_file_path, headerfile=paste(L8_file_path, ".hdr", sep=""))

L8_raster_extent <- extent(L8_raster) # where raster <- brick(hdr_file_path, headerfile=paste(L8_hdr_file_path, ".hdr", sep=""))

# new_extent <- c(348000, 350000, -2020000, -2018000) # ADAR
# new_extent <- c(326000, 328000, -1356500, -1355000) # BRDN

L8_colony <- L8_raster[[1]] 
colony_hits <- which(L8_colony[] == 1) # cell numbers where the algorithm says the colony is

REMA_subset <- crop(REMA_raster, L8_raster_extent)
# REMA_subset <- crop(REMA_raster, new_extent)
# L8_colony <- crop(L8_colony, new_extent)

rm(REMA_raster) # don't really need this anymore
# REMA_subset[REMA_subset < -0] <- 0 # zero out any -999s or whatever

# plot(L8_colony)
# plot(REMA_subset)

# resample the REMA DEM from 8x8m resolution to the L8 30x30m resolution
REMA_subset_30x30m_resolution <- projectRaster(REMA_subset, L8_colony, method="ngb") # "ngb" = nearest neighbor; or "bilinear"

rvals <- REMA_subset_30x30m_resolution[colony_hits] 
print(rvals)
print(mean(rvals))
print("")

# find the index of values for the NaNs and NAs
REMA_subset_30x30m_resolution_NaNs <- which(is.nan(REMA_subset_30x30m_resolution)[] == TRUE)
# find the index of values for void areas (in theory with values = -9999, but I get values = -9943.69)
REMA_subset_30x30m_resolution_voids <- which(REMA_subset_30x30m_resolution[] < -1000)
REMA_subset_30x30_resolution_bogus_values <- c(REMA_subset_30x30m_resolution_NaNs, REMA_subset_30x30m_resolution_voids)

# for some reason REMA values near the shoreline are below sea level, this at least ensures that all DEM values on a colony are >0
# first turn all of the NaNs and NAs into 0
REMA_subset_30x30m_resolution[REMA_subset_30x30_resolution_bogus_values] <- 0 
# find the lowest value within the subset of colony hits
lowest_value <- ceiling(min(REMA_subset_30x30m_resolution[colony_hits]))
if (lowest_value < 0) { lowest_value <- abs(lowest_value) + 1} else lowest_value <- 0 # add 1 because ceiling of a neg number goes the "wrong" way
# then elevate all of the colony landscape above sea level (no negative elevation values)
REMA_subset_30x30m_resolution <- REMA_subset_30x30m_resolution + lowest_value # can't add a value to a NA or NaN
# and return all the elevations that were NAs and NaNs to 0 after adding the delta value in the line above
REMA_subset_30x30m_resolution[REMA_subset_30x30_resolution_bogus_values] <- 0 

plot(REMA_subset_30x30m_resolution, main=c_name, xlab="easting", ylab="northing")

# create a color table with all elements = 0 EXCEPT the element that corresponds to values = 1
colortable(L8_colony) <- c(c("#00000000", "#0000FFAA"), rep("#00000000", 254), sep=",") # FF0000 = red, last 2 digits = alpha
plot(L8_colony, add=T)

rvals <- REMA_subset_30x30m_resolution[colony_hits] 

print(rvals)

zero_elevation_raster <- REMA_subset_30x30m_resolution # make another raster with the same crs, etc as the one we are using
zero_elevation_index <- which(REMA_subset_30x30m_resolution[] == 0)
zero_elevation_raster[] <- 0
zero_elevation_raster[zero_elevation_index] <- 1 # put a 1 where the elevation is 0
colortable(zero_elevation_raster) <- c(c("#00000000", "#ff33e070"), rep("#00000000", 254), sep=",") # FF0000 = red, last 2 digits = alpha
plot(zero_elevation_raster, add=T)

print("DONE!")



