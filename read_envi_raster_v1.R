# read ENVI-formatted files

library(raster)

################################## configurable parameters ###################################
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/ADAR_LC80631102013319/ADAR_LC80631102013319_Dec13h17m14s37y2017"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/CROZ_LC80521162014309/CROZ_LC80521162014309_Dec13h22m01s15y2017"
L8_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/ENVI_chips_REMA_tiles/BRDN_LC80531162013361/BRDN_LC80531162013361_Dec13h22m02s17y2017"




# adar_raster <- raster(adar_hdr_file_path, headerfile=paste(adar_hdr_file_path, ".hdr", sep=""))
L8_raster <- brick(L8_file_path, headerfile=paste(L8_file_path, ".hdr", sep=""))

#plotRGB(L8_raster, r=6, g=7, b=8, stretch="hist")

# a matrix file with valid pixel values of 0,1,-999 where 0 indicates that no Adelie
# colony is present, 1 indicates that an Adelie colony is present at that pixel, and
# -999 indicates missing data which is most likely due to scan line data drop-outs
# found during the "Landsat-7 Scan Line Corrector Off" era or it may be due to the
# condition where the Adelie colony was found at the edge of a Landsat scan and part
# of the colony falls into the fill pixels at the scene border.
L8_colony <- L8_raster[[1]] 
# adar_colony[L8_colony == -999] <- 0

red1 <- L8_raster[[6]]
red1[L8_colony == 1] <- 10000

green1 <- L8_raster[[7]]
green1[L8_colony == 1] <- 0

blue1 <- L8_raster[[8]]
blue1[L8_colony == 1] <- 10000

b1 <- brick(red1, green1, blue1)
plotRGB(b1, r=1, b=2, g=3, stretch="lin")

print("DONE!")

