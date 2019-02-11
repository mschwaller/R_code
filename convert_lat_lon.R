library(rgdal)
library(sp)
y <- c(34.0, 36.5)   # latitudes
x <- c(-80.0,-75.0)  # longitudes

d <- data.frame(lon=x, lat=y)
print(d)
coordinates(d) <- c("lon", "lat")
proj4string(d) <-  CRS("+proj=longlat +datum=WGS84") # WGS 84
CRS.new <- CRS("+init=epsg:2264")

d.ch2264 <- spTransform(d, CRS.new)

print(unclass(d.ch2264))