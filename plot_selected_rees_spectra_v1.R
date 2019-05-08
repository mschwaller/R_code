# this script plots the Rees guano spectra

spec_names <- c("wavelength","Rees_Adelie_100_1756","Rees_Adelie_100_1757","Rees_Adelie_100_1758","Rees_Adelie_100_1759",
                "Rees_Adelie_100_1760","Rees_Adelie_100_1761","Rees_Adelie_100_1762","Rees_Adelie_100_1779",
                "Rees_Adelie_100_1780","Rees_Adelie_100_1781","Rees_Adelie_100_1782","Rees_Adelie_100_1849",
                "Rees_Adelie_100_1850","Rees_Adelie_100_1851","Rees_Adelie_100_1852","Rees_Adelie_100_1853",
                "Rees_Adelie_100_1854")

# read in the guano spectra
guano_spectra <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/Rees_penguin_guano_data_selected_by_photo_17only_v2.csv", 
                          header=TRUE, sep=",")

# put the guano spectra into a matrix
guano_spectra_matrix <- as.matrix(guano_spectra)
plot(guano_spectra_matrix[,1], guano_spectra_matrix[,2], type="l", xlab="wavelength nm", ylab="reflectance", ylim=c(0,0.6))
num_cols <- length(guano_spectra_matrix[1,]) # number of cols, 1st col is wavelengths
# start plotting the 3rd column of spectra
for (ii in 2:num_cols) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  if (ii>=9 & ii<=12) {
    pcolor <- "red"
    plwd <- 1
  } else if (ii==14){
    pcolor <- "red"
    plwd <- 3
  } else
  {
    pcolor <- "black"
    plwd <- 1}
  lines(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], col=pcolor, lwd=plwd)
}


# do the same thing for all the other band RSRs
b1_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/band1_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b1_matrix = matrix(ncol=2,nrow=length(b1_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b1_matrix[,1]=b1_RSR[,1]
b1_matrix[,2]=b1_RSR[,5]

b2_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/band2_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b2_matrix = matrix(ncol=2,nrow=length(b2_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b2_matrix[,1]=b2_RSR[,1]
b2_matrix[,2]=b2_RSR[,5]

b3_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/band3_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b3_matrix = matrix(ncol=2,nrow=length(b3_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b3_matrix[,1]=b3_RSR[,1]
b3_matrix[,2]=b3_RSR[,5]

b4_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/band4_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b4_matrix = matrix(ncol=2,nrow=length(b4_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b4_matrix[,1]=b4_RSR[,1]
b4_matrix[,2]=b4_RSR[,5] 

b5_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/band5_RSR_SWIR1_filter_functions.txt", header=FALSE, sep=",", skip=2)
b5_matrix = matrix(ncol=2,nrow=length(b5_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b5_matrix[,1]=b5_RSR[,1]
b5_matrix[,2]=b5_RSR[,5]

b7_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/band7_RSR_SWIR2_filter_functions.txt", header=FALSE, sep=",", skip=2)
b7_matrix = matrix(ncol=2,nrow=length(b7_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b7_matrix[,1]=b7_RSR[,1]
b7_matrix[,2]=b7_RSR[,5]

#plot(b1_RSR[,1], b1_RSR[,2], type="l", xlab="wavelength nm", ylab="relative spectral response", ylim=c(0,1.0), xlim=c(300,2500))
lines(b1_RSR[,1], 0.5*b1_RSR[,2], col="blue")
lines(b2_RSR[,1], 0.5*b2_RSR[,2], col="blue")
lines(b3_RSR[,1], 0.5*b3_RSR[,2], col="blue")
lines(b4_RSR[,1], 0.5*b4_RSR[,2], col="blue")
lines(b5_RSR[,1], 0.5*b5_RSR[,2], col="blue")
lines(b7_RSR[,1], 0.5*b7_RSR[,2], col="blue")

print("DONE!")
