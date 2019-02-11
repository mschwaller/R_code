# this script plots the PR counties and will eventually add the ARIA dammage points for Hurriacane Maria

print("starting")

# first, add some libraries
library(sp)
library(raster)
library(rgdal)
library(maptools)

# partial path to the ARIA data
path_vec_east <- c("20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s2_04_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s2_05_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s2_06_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s2_07_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s2_08_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s3_05_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s3_06_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s3_07_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s3_08_c0.7g1_T1H0B0U1_dpm.tif","20170921_1014z_PuertoRico_S1_DPM_NASA_ARIA_v0.4_geotiff/DPM_Maria_S1_s3_09_c0.7g1_T1H0B0U1_dpm.tif")
path_vec_west <- c("20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s1_01_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s1_02_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s1_03_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s1_04_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s2_01_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s2_02_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s2_03_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s2_04_c0.6g1_T1H0B0U1_dpm.tif","20170926_1023z_PuertoRicoWest_S1_DPM_NASA_ARIA_v0.5_geotiff/DPM_Maria_S1_s2_10_c0.6g1_T1H0B0U1_dpm.tif")
path_vec_all <- c(path_vec_east, path_vec_west)

# open the shapefile of county boundaries
PR_counties <- readOGR(dsn="/Users/mschwall/Desktop/hurricane_maria/nhgis0042_shapefile_tl2016_us_county_2016", layer="US_county_2016") # ingest the shapefile
lat_lon_projection <- CRS("+proj=longlat +datum=WGS84") # the basic geographic lat,lon projections
PR_counties_latlon <- spTransform(PR_counties, lat_lon_projection) # convert the nhgis0042_shapefile_tl2016_us_county_2016 projection to geographic lat,lon
plot(PR_counties_latlon, xlim=c(-67.5, -64.5), ylim=c(17.5, 18.5 ), xlab="longitude degrees", ylab="latitude degrees")
box() # put a box around the plot
axis(1) # and add the axis ticks
axis(2)

# now open each of the geotiffs (there are 10 for the eastern part & 9 for the western part) and plot their points on the map
use_this_vec <- path_vec_all
num_tifs <- length(use_this_vec)
for (ii in 1:num_tifs) {
  print(c("starting iteration", ii))
  tiff_name <- paste("/Users/mschwall/Desktop/hurricane_maria/", use_this_vec[ii], sep="")
  # open 4th band of the tiff as a raster because I found that this band has the largest number of hits that I'm guessing are equivalent to Maria damage hotspots
  PR_tiff1 <- raster(tiff_name, band=2) 
  crs(PR_tiff1) <- lat_lon_projection # use the same projections for the raster
  PR_data <- rasterToPoints(PR_tiff1) # convert the raster to a lon,lat,value matrix
  points(PR_data[which(PR_data[,3] < 255),1], PR_data[which(PR_data[,3] < 255),2], pch=19, 
         col = rgb(red=1, green=0, blue=0, alpha=0.5), cex=0.01) # plot the location of the points with values > 0
}

