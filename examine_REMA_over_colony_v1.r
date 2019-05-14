# read and plot a REMA tile

library(raster)
library(rasterVis)
par(mar=c(5.1, 4.1, 4.1, 2.1))

################################## configurable parameters ###################################
# ADAR
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/10_34_8m_ADAR/10_34_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/ADAR_LC80631102013319/ADAR_LC80631102013319_Dec13h17m14s37y2017"
# CROZ
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/17_33_8m_CROZ/17_33_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/CROZ_LC80521162014309/CROZ_LC80521162014309_Dec13h22m01s15y2017"
# BRDN
REMA_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/17_34_8m_BRDN/17_34_8m_dem.tif"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/BRDN_LC80531162013361/BRDN_LC80531162013361_Dec13h22m02s17y2017"

REMA_raster <- raster(REMA_file_path)
L8_raster <- brick(L8_file_path, headerfile=paste(L8_file_path, ".hdr", sep=""))

L8_raster_extent <- extent(L8_raster) # where raster <- brick(hdr_file_path, headerfile=paste(L8_hdr_file_path, ".hdr", sep=""))
REMA_subset <- crop(REMA_raster, L8_raster_extent)
rm(REMA_raster) # don't really need this anymore

L8_colony <- L8_raster[[1]] # pick out the colony image, values of 1=colony, 0=not colony, -999=no data

# subset REMA to match the Landsat resolution
REMA_subset_30x30m_resolution <- projectRaster(REMA_subset, L8_colony, method="ngb") # "ngb" = nearest neighbor; or "bilinear"
# log_REMA_subset_30x30m_resolution <- log10(REMA_subset_30x30m_resolution + 1)
plot(REMA_subset_30x30m_resolution)


L8_colony_mat <- as.matrix(L8_raster[[1]])
colony_hits <- which(L8_colony_mat == 1)

rvals <- extract(REMA_subset_30x30m_resolution, colony_hits)

colortable(L8_colony) <- c(c("#00000000", "#FF000099"), rep("#00000000", 254), sep=",") # FF0000 = red, last 2 digits = alpha

print(rvals)




