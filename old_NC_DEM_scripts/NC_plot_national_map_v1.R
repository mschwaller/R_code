print("reading NC national map raster")

lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections

source_file_img <- c("/Users/mschwall/Desktop/impervious/national_map_NC/n35w079/imgn35w079_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w080/imgn35w080_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n35w081/imgn35w081_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n36w080/imgn36w080_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n37w081/imgn37w081_13.img",
"/Users/mschwall/Desktop/impervious/national_map_NC/n36w081/grdn36w081_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/n37w080/grdn37w080_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n35w077_ArcGrid/grdn35w077_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n35w078_ArcGrid/grdn35w078_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w076_ArcGrid/grdn36w076_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w077_ArcGrid/grdn36w077_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w078_ArcGrid/grdn36w078_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w083_ArcGrid/grdn36w083_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n36w084_ArcGrid/grdn36w084_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w076_ArcGrid/grdn37w076_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w077_ArcGrid/grdn37w077_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w078_ArcGrid/grdn37w078_13/w001001.adf",
"/Users/mschwall/Desktop/impervious/national_map_NC/USGS_NED_13_n37w082_ArcGrid/grdn37w082_13/w001001.adf")

xbounds <- c(-84,-84,-75,-75)
ybounds <- c(33,38,33,38)
plot(xbounds, ybounds, xlim=c(-84, -75), ylim=c(33, 38))

num_files <- length(source_file_img)

for (ii in 1:4) {
  print(ii)
  print(source_file_img[ii])
  nc_image <- raster(source_file_img[ii])
  crs(nc_image) <- lat_lon_projection
  plot(nc_image, add=TRUE)
  }

box()
axis(1)
axis(2)
#plot(nc_image)