
print("starting!")
library(stringr)
library(sp)
library(raster)
library(rgdal)
library(stringr)
dem_filepath <- "/Users/mschwall/Desktop/impervious/national_map_NC"
dem_dirs <- list.dirs(path=dem_filepath, recursive=FALSE, full.names=FALSE)
all_dem_files <- list.files(path=dem_filepath, recursive=TRUE, full.names=TRUE)
num_dirs <- length(dem_dirs)
paths_array <- vector(mode="character", length=num_dirs)
num_files <- length(all_dem_files)
for (ii in 1:num_files) {
  if ((str_detect(all_dem_files[ii],"1001.adf") == TRUE)) {
    print(all_dem_files[ii])
  }
  if ((str_detect(all_dem_files[ii], "ned_13arcsec_g.shp") == TRUE)  & ((str_detect(all_dem_files[ii], "ned_13arcsec_g.shp.xml") == FALSE))) {
    print(all_dem_files[ii])
  }
  }

