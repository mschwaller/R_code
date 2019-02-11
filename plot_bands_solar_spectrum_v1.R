# this script plots the petrel guano spectra

# read in the solar spectrum from https://www.nrel.gov/grid/solar-resource/spectra.html
# column 1 = wavelength, column 4 = surface spectral irradiance W/(m2 nm)
solar_spectrum <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/solar_spectrum_AM0AM1_5_csv.txt", header=FALSE, sep=",", skip=0)
# put the solar spectrum into a matrix
solar_spectrum_matrix <- as.matrix(solar_spectrum)

# read in the TM series of band RSRs
# nm L7 L4 L5 L8
band1 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band1_RSR_filter_functions.txt", sep=",", skip=3)
band2 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band2_RSR_filter_functions.txt", sep=",", skip=3)
band3 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band3_RSR_filter_functions.txt", sep=",", skip=3)
band5 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band5_RSR_SWIR1_filter_functions.txt", sep=",", skip=3)
band7 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/cross_calibration/Landsat filter function plots/band7_RSR_SWIR2_filter_functions.txt", sep=",", skip=3)
band1_mat <- as.matrix(band1)
band2_mat <- as.matrix(band2)
band3_mat <- as.matrix(band3)
band5_mat <- as.matrix(band5)
band7_mat <- as.matrix(band7)

p_color<- c("black", "blue", "green", "red")

plot(band1_mat[,1], band1_mat[,2], type="l", xlab="wavelength nm", ylab="band relative spectral response", ylim=c(0,2.0), xlim=c(400,2500), col=p_color[1])
# start plotting the 3rd column of spectra
# note TM4 & TM5 filter functions are almost identical (lines cover one another)
for (ii in 3:5) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(band1_mat[,1], band1_mat[,ii], col=p_color[ii-1])
}

lines(band2_mat[,1], band2_mat[,2], col=p_color[1])
# start plotting the 3rd column of spectra
# note TM4 & TM5 filter functions are almost identical (lines cover one another)
for (ii in 3:5) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(band2_mat[,1], band2_mat[,ii], col=p_color[ii-1])
}

lines(band3_mat[,1], band3_mat[,2], col=p_color[1])
# start plotting the 3rd column of spectra
# note TM4 & TM5 filter functions are almost identical (lines cover one another)
for (ii in 3:5) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(band3_mat[,1], band3_mat[,ii], col=p_color[ii-1])
}

lines(band5_mat[,1], band5_mat[,2], col=p_color[1])
# start plotting the 3rd column of spectra
# note TM4 & TM5 filter functions are almost identical (lines cover one another)
for (ii in 3:5) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(band5_mat[,1], band5_mat[,ii], col=p_color[ii-1])
}

lines(band7_mat[,1], band7_mat[,2], col=p_color[1])
# start plotting the 3rd column of spectra
# note TM4 & TM5 filter functions are almost identical (lines cover one another)
for (ii in 3:5) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(band7_mat[,1], band7_mat[,ii], col=p_color[ii-1])
}


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
