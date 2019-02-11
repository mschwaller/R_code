# this script plots the petrel guano spectra

# read in the solar spectrum from https://www.nrel.gov/grid/solar-resource/spectra.html
# column 1 = wavelength, column 4 = surface spectral irradiance W/(m2 nm)
solar_spectrum <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/solar_spectrum_AM0AM1_5_csv.txt", header=FALSE, sep=",", skip=0)
# put the solar spectrum into a matrix
solar_spectrum_matrix <- as.matrix(solar_spectrum)

# read in the TM series of band RSRs
# nm L7 L4 L5 L8
band1 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band1_RSR_filter_functions.txt", sep=",", skip=3, header=FALSE)
band2 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band2_RSR_filter_functions.txt", sep=",", skip=3, header=FALSE)
band3 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band3_RSR_filter_functions.txt", sep=",", skip=3, header=FALSE)
band4 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band4_RSR_filter_functions.txt", sep=",", skip=3, header=FALSE)
band5 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band5_RSR_SWIR1_filter_functions.txt", sep=",", skip=3, header=FALSE)
band7 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band7_RSR_SWIR2_filter_functions.txt", sep=",", skip=3, header=FALSE)
band1_mat <- as.matrix(band1)
band2_mat <- as.matrix(band2)
band3_mat <- as.matrix(band3)
band4_mat <- as.matrix(band4)
band5_mat <- as.matrix(band5)
band7_mat <- as.matrix(band7)

p_color<- c("black", "blue", "green", "red")

plot(band1_mat[,1], band1_mat[,2], type="l", xlab="wavelength nm", ylab="band relative spectral response", ylim=c(0,2.0), xlim=c(400,2500), col=p_color[1])
lines(band2_mat[,1], band2_mat[,2], col=p_color[1])
lines(band3_mat[,1], band3_mat[,2], col=p_color[1])
lines(band4_mat[,1], band4_mat[,2], col=p_color[1])
lines(band5_mat[,1], band5_mat[,2], col=p_color[1])
lines(band7_mat[,1], band7_mat[,2], col=p_color[1])

mss1_l <- c(499, 500, 600, 601)
mss2_l <- c(599, 600, 700, 701)
mss3_l <- c(699, 700, 800, 801)
mss4_l <- c(799, 800, 1100, 1101)

mss1_r <- c(0,1,1,0)
mss2_r <- c(0,1,1,0)
mss3_r <- c(0,1,1,0)
mss4_r <- c(0,1,1,0)

lines(mss1_l, mss1_r, col=p_color[4])
lines(mss2_l, mss2_r, col=p_color[4])
lines(mss3_l, mss3_r, col=p_color[4])
lines(mss4_l, mss4_r, col=p_color[4])


# plot the solar spectrum
par(new=TRUE)
plot(solar_spectrum_matrix[,1], solar_spectrum_matrix[,4],,type="l",col="blue",xaxt="n",yaxt="n",xlab="",ylab="", xlim=c(400,2500))
axis(4)
mtext("y2",side=4,line=3)
#plot(solar_spectrum_matrix[,1], solar_spectrum_matrix[,4], type="l", xlab="wavelength nm", ylab="solar irradiance at the surface", ylim=c(0,2.0), xlim=c(280.,2500))
#num_cols <- length(solar_spectrum_matrix[1,]) # number of cols, 1st col is wavelengths
# start plotting the 3rd column of spectra
#for (ii in 3:num_cols) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
#  lines(solar_spectrum_matrix[,1], solar_spectrum_matrix[,ii])
#}
