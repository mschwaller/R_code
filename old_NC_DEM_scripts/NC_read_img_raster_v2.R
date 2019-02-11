source_dir <- "/Users/mschwall/Desktop/impervious/nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10/"
source_file_img <- paste(source_dir, "nlcd_2006_to_2011_landcover_fromto_change_index_2011_edition_2014_10_10.img", sep="")

# load in map and locality data
NLCD<-raster (source_file_img)
sites<-read.csv('sites.csv', header=T)
#crop site data to just latitude and longitude
sites<-sites[,4:5]
#convert lat/lon to appropirate projection
str (sites)
coordinates(sites)  <-  c("Longitude",  "Latitude")
proj4string(sites)  <- CRS("+proj=longlat +ellps=WGS84 +datum=WGS84")
sites_transformed<-spTransform(sites, CRS("+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"))

#plot the map
plot (NLCD)
#add the converted x y points
points (sites_transformed, pch=16, col="red", cex=.75)
#extract values to poionts
Landcover<-extract (NLCD, sites_transformed, buffer=1000)