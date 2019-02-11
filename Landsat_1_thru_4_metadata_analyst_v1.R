# this script ingests the Landsats 1-4 metadata. Note that the path,row coordinates for 
# Landsats 1-4 are in WRS-1 format

# configurable parameters
max_cloud_cover_pct <- 100        # in percent
min_sun_elevation_deg <- 15      # in degrees
max_cloud_cover_land_pct <- 100   # in percent
start_dates <- c("1972-01-01","1973-01-01","1974-01-01","1975-01-01","1976-01-01","1977-01-01","1978-01-01","1979-01-01","1980-01-01",
                 "1981-01-01","1982-01-01","1983-01-01","1984-01-01","1985-01-01","1986-01-01","1987-01-01","1988-01-01","1989-01-01",
                 "1990-01-01","1991-01-01","1992-01-01","1993-01-01","1994-01-01","1995-01-01","1996-01-01","1997-01-01","1998-01-01",
                 "1999-01-01","2000-01-01","2001-01-01","2002-01-01","2003-01-01","2004-01-01","2005-01-01","2006-01-01","2007-01-01",
                 "2008-01-01","2009-01-01","2010-01-01","2011-01-01","2012-01-01","2013-01-01")
end_dates <- c("1972-12-31","1973-12-31","1974-12-31","1975-12-31","1976-12-31","1977-12-31","1978-12-31","1979-12-31",
               "1980-12-31","1981-12-31","1982-12-31","1983-12-31","1984-12-31","1985-12-31","1986-12-31","1987-12-31",
               "1988-12-31","1989-12-31","1990-12-31","1991-12-31","1992-12-31","1993-12-31","1994-12-31","1995-12-31",
               "1996-12-31","1997-12-31","1998-12-31","1999-12-31","2000-12-31","2012-31-01","2002-12-31","2003-12-31",
               "2004-12-31","2005-12-31","2006-12-31","2007-12-31","2008-12-31","2009-12-31","2010-12-31","2011-12-31",
               "2012-12-31","2013-12-31")
date_totals <- data.frame("date"=c(rep(1972:2013,1)), "LM01"=c(rep(0,2013-1972+1)), "LM02"=c(rep(0,2013-1972+1)), "LM03"=c(rep(0,2013-1972+1)),
                          "LM04"=c(rep(0,2013-1972+1)), "LM05"=c(rep(0,2013-1972+1)), "totals"=c(rep(0,2013-1972+1)))

meta_picker <- c(rep("NULL", 46)) # make a vector with 46 NULLs, there are 46 metadata categories in the L1 MSS metadata file
meta_picker[c(4,8,10,11,35)] <- "integer"    # cloudCover, path, row, CLOUD_COVER_LAND 
meta_picker[c(7)] <- "numeric"               # sunElevation
meta_picker[c(16,24,25,45)] <- "character"   # dayOrNight, LANDSAT_PRODUCT_ID, acquisitionDate, sceneID
meta_picker[c(3,19,30,40)] <- "numeric"      # latitude UR, LR, LL, UL
meta_picker[c(26,29,36,33)] <- "numeric"     #longitude UR, LR, LL, UL # wacky indexing!
# these metadata categories are respectively cloudCOver, sunElevation, path, row, imageQuality1,
# dayOrNight, LANDSAT_PRODUCT_ID, acquisitionDate, CLOUD_COVER_LAND, sceneID
# we want to select only these categories from the bulk metadata file

# ingest the Landsat MSS metadata (includes L1,2,3,4,5) but select only the categories specified by colClasses
mss_meta_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/LANDSAT_MSS_metadata_C1.txt", 
                 header=TRUE, sep=",", skip=0, colClasses=meta_picker) # skip the metadata columns where meta_picker == NULL
mss_meta_frame$satID <- substr(mss_meta_frame$LANDSAT_PRODUCT_ID,1,4) # add one new column of sat IDs: LM05, LM04, LM03, LM02, LM01

# ingest the set of WRS1 path,row coordinates that cover known Adelie, Gentoo & Chinstrap colonies
wrs1_path_row_coord_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/wrs1_coords_over_colonies_v1.txt", 
                                 header=FALSE, sep=",", skip=0, col.names=c("path", "row"))

wrs1_path_hits <- is.element(mss_meta_frame$path, unique(wrs1_path_row_coord_frame$path)) # vector of TRUE where there is a path hit & FALSE where there isn't
wrs1_row_hits  <- is.element(mss_meta_frame$row,  unique(wrs1_path_row_coord_frame$row)) # vector of TRUE where there is a row hit & FALSE where there isn't

# find the indices of all LM01, 02, 03 (WSR-1)
Landsat_123_index <- which(((mss_meta_frame$satID == "LM01") | (mss_meta_frame$satID == "LM02") | (mss_meta_frame$satID == "LM03")) 
                     & (mss_meta_frame$sunElevation >= min_sun_elevation_deg)  
                     & ((mss_meta_frame$cloudCover < max_cloud_cover_pct) | (mss_meta_frame$CLOUD_COVER_LAND < max_cloud_cover_land_pct))
                     & (wrs1_path_hits & wrs1_row_hits)) 

num_dates <- length(start_dates)
total_obs <- 0
for (ii in 1:num_dates) {
  date_index <- which((mss_meta_frame$acquisitionDate[Landsat_123_index] >= start_dates[ii]) 
                      & (mss_meta_frame$acquisitionDate[Landsat_123_index] <= end_dates[ii]))
  print(paste(1971+ii, length(date_index), sep="  "))
  total_obs <- total_obs + length(date_index)
  date_totals$LM01[ii] <- date_totals$LM01[ii] + length(which(mss_meta_frame$satID[Landsat_123_index[date_index]] == "LM01"))
  date_totals$LM02[ii] <- date_totals$LM02[ii] + length(which(mss_meta_frame$satID[Landsat_123_index[date_index]] == "LM02"))
  date_totals$LM03[ii] <- date_totals$LM03[ii] + length(which(mss_meta_frame$satID[Landsat_123_index[date_index]] == "LM03"))
  
}
print(total_obs)

# now do the same thing for WRS2
# ingest the set of WRS2 path,row coordinates that cover known Adelie, Gentoo & Chinstrap colonies
wrs2_path_row_coord_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/wrs2_coords_over_colonies_v1.txt", 
                                      header=FALSE, sep=",", skip=0, col.names=c("path", "row"))

wrs2_path_hits <- is.element(mss_meta_frame$path, unique(wrs2_path_row_coord_frame$path)) # vector of TRUE where there is a path hit & FALSE where there isn't
wrs2_row_hits  <- is.element(mss_meta_frame$row,  unique(wrs2_path_row_coord_frame$row)) # vector of TRUE where there is a row hit & FALSE where there isn't

# find the indices of all LM04 and LM05 (WSR-2) that meet various selection criteria
Landsat_45_index <- which(((mss_meta_frame$satID == "LM04") | (mss_meta_frame$satID == "LM05")) 
                           & (mss_meta_frame$sunElevation >= min_sun_elevation_deg)  
                           & ((mss_meta_frame$cloudCover < max_cloud_cover_pct) | (mss_meta_frame$CLOUD_COVER_LAND < max_cloud_cover_land_pct))
                           & (wrs2_path_hits & wrs2_row_hits)) 

num_dates <- length(start_dates)
# total_obs <- 0
for (ii in 1:num_dates) {
  date_index <- which((mss_meta_frame$acquisitionDate[Landsat_45_index] >= start_dates[ii]) 
                      & (mss_meta_frame$acquisitionDate[Landsat_45_index] <= end_dates[ii]))
  print(paste(1971+ii, length(date_index), sep="  "))
  total_obs <- total_obs + length(date_index)
  date_totals$LM04[ii] <- date_totals$LM04[ii] + length(which(mss_meta_frame$satID[Landsat_45_index[date_index]] == "LM04"))
  date_totals$LM05[ii] <- date_totals$LM05[ii] + length(which(mss_meta_frame$satID[Landsat_45_index[date_index]] == "LM05"))
  
}
print(total_obs)

# write hits into separate Landsat 1,2,3 and Landsat 4,5 files
#out_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_R_all_cols_L123.txt"
#write.table(mss_meta_frame[Landsat_123_index,], file=out_file_path, row.names=FALSE, col.names=TRUE, sep=",")
#out_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_R_all_cols_L45.txt"
#write.table(mss_meta_frame[Landsat_45_index,], file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)

# write all hits into one file
#out_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_R_all_cols.txt"
#write.table(mss_meta_frame[Landsat_123_index,], file=out_file_path, row.names=FALSE, col.names=TRUE, sep=",")
#write.table(mss_meta_frame[Landsat_45_index,], file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)

date_totals$totals <- date_totals$LM01 + date_totals$LM02 + date_totals$LM03 + date_totals$LM04 + date_totals$LM05

print("DONE!")
