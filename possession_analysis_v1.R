# this script plots the PR counties and will eventually add the ARIA dammage points for Hurriacane Maria

print("starting")

# first, add some libraries
library(sp)
library(raster)
library(rgdal)
library(maptools)

dem_11_34 <- raster("/Users/mschwall/Desktop/11_34_8m_dem.tif")
poss_ext <- extent(302888, 305072, -1961296, -1958808)
poss_dem <- crop(dem_11_34, poss_ext)
plot(poss_dem, xlab="easting", ylab="northing", main="Possession Island REMA Contour Plot\nelevation in meters")
contour(poss_dem, add=TRUE, levels=c(-45,-40,-30,-20,-10,0,10,20,30), labels="", col="red")
contour(poss_dem, add=TRUE, levels=c(-45,-40,-30,-20,-10,0,10,20,30), lty=0, labcex=1.0, col="black", vfont=c("sans serif", "bold"))




