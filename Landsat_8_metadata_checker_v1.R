# this script ingests the Landsats 1-4 metadata. Note that the path,row coordinates for 
# Landsats 1-4 are in WRS-1 format

# read in the scene info for the scenes that Chris ordered
ordered_scenes <- readRDS(file = "/Users/mschwall/LandsatSeesAdelies/LandsatSeesAdelies/Library/SiteSceneL4578.rds")
matt_scenes <- ordered_scenes[which(ordered_scenes$source == "MS"),]
rm(ordered_scenes)

# now do the same thing for WRS2
# ingest the set of WRS2 path,row coordinates that cover known Adelie, Gentoo & Chinstrap colonies
#L8_metadata_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/Landsat_8_metadata/Landsat_8_C1.csv", 
#                              header=TRUE, sep=",", skip=0, 
#                              colClasses=c("NULL","NULL",NA,"NULL","NULL",NA,"NULL","NULL",NA,NA,"NULL","NULL","NULL",NA,NA,"NULL","NULL","NULL","NULL","NULL",NA,"NULL",
#                                          "NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL",NA,NA,"NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL",
#                                          "NULL","NULL",NA,"NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL","NULL",NA,"NULL","NULL","NULL","NULL"))

num_rows <- length(matt_scenes[,1])
for (jj in 1:num_rows) {
  index <- which(L8_metadata_frame$LANDSAT_PRODUCT_ID == matt_scenes[jj,]$Landsat.Product.Identifier)
  if (length(index) == 0) next # skip this iteration if the matt_scene isn't found in the ordered scenes (probably because its scene_ID is different)
  s_result <- L8_metadata_frame[index,]
  print(s_result)
}

print("DONE!")
