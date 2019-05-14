# read and plot a REMA tile

library(raster)
library(rasterVis)
par(mar=c(5.1, 4.1, 4.1, 2.1))

################################## configurable parameters ###################################
# CROZ
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/17_33_8m_CROZ/17_33_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/CROZ_LC80521162014309/CROZ_LC80521162014309_Dec13h22m01s15y2017"
# BRDN
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/17_34_8m_BRDN/17_34_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/BRDN_LC80531162013361/BRDN_LC80531162013361_Dec13h22m02s17y2017"
# ADAR
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/10_34_8m_ADAR/10_34_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/ADAR_LC80631102013319/ADAR_LC80631102013319_Dec13h17m14s37y2017"

REMA_raster <- raster(REMA_file_path)
L8_raster <- brick(L8_file_path, headerfile=paste(L8_file_path, ".hdr", sep=""))

L8_raster_extent <- extent(L8_raster) # where raster <- brick(hdr_file_path, headerfile=paste(L8_hdr_file_path, ".hdr", sep=""))
REMA_subset <- crop(REMA_raster, L8_raster_extent)
rm(REMA_raster) # don't really need this anymore
REMA_subset[REMA_subset < -0] <- 0 # zero out any -999s or whatever

L8_colony <- L8_raster[[1]] 

# plot(L8_colony)
# plot(REMA_subset)

REMA_subset_30x30m_resolution <- projectRaster(REMA_subset, L8_colony, method="bilinear")
log_REMA_subset_30x30m_resolution <- log10(REMA_subset_30x30m_resolution + 1)
plot(REMA_subset_30x30m_resolution)

# (REMA_subset)
# plot3D(REMA_subset_30x30m_resolution, drape=L8_colony)
plot3D(REMA_subset_30x30m_resolution, drape=L8_colony)

print("DONE!")



