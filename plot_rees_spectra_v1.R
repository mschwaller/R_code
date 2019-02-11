# this script plots the Rees guano spectra

# read in the guano spectra
guano_spectra <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/Rees_penguin_guano_data_selected_by_photo_v2.csv", header=FALSE, sep=",", skip=10)

# put the guano spectra into a matrix
guano_spectra_matrix <- as.matrix(guano_spectra)
plot(guano_spectra_matrix[,1], guano_spectra_matrix[,2], type="l", xlab="wavelength nm", ylab="reflectance", ylim=c(0,0.6))
num_cols <- length(guano_spectra_matrix[1,]) # number of cols, 1st col is wavelengths
# start plotting the 3rd column of spectra
for (ii in 3:num_cols) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(guano_spectra_matrix[,1], guano_spectra_matrix[,ii])
}

# read in the Landsat 8 band 1 Relative Spectral Response from file Ball_BA_RSR.xlsx (find it on the web)
b1_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band1_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b1_matrix = matrix(ncol=2,nrow=length(b1_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b1_matrix[,1]=b1_RSR[,1]
b1_matrix[,2]=b1_RSR[,5]

# do the same thing for all the other band RSRs
b1_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band1_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b1_matrix = matrix(ncol=2,nrow=length(b1_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b1_matrix[,1]=b1_RSR[,1]
b1_matrix[,2]=b1_RSR[,5]

b2_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band2_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b2_matrix = matrix(ncol=2,nrow=length(b2_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b2_matrix[,1]=b2_RSR[,1]
b2_matrix[,2]=b2_RSR[,5]

b3_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band3_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b3_matrix = matrix(ncol=2,nrow=length(b3_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b3_matrix[,1]=b3_RSR[,1]
b3_matrix[,2]=b3_RSR[,5]

b4_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band4_RSR_filter_functions.txt", header=FALSE, sep=",", skip=2)
b4_matrix = matrix(ncol=2,nrow=length(b4_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b4_matrix[,1]=b4_RSR[,1]
b4_matrix[,2]=b4_RSR[,5] 

b5_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band5_RSR_SWIR1_filter_functions.txt", header=FALSE, sep=",", skip=2)
b5_matrix = matrix(ncol=2,nrow=length(b5_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b5_matrix[,1]=b5_RSR[,1]
b5_matrix[,2]=b5_RSR[,5]

b7_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band7_RSR_SWIR2_filter_functions.txt", header=FALSE, sep=",", skip=2)
b7_matrix = matrix(ncol=2,nrow=length(b7_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b7_matrix[,1]=b7_RSR[,1]
b7_matrix[,2]=b7_RSR[,5]

plot(b1_RSR[,1], b1_RSR[,2], type="l", xlab="wavelength nm", ylab="relative spectral response", ylim=c(0,1.0), xlim=c(300,2500))
lines(b2_RSR[,1], b2_RSR[,2])
lines(b3_RSR[,1], b3_RSR[,2])
lines(b4_RSR[,1], b4_RSR[,2])
lines(b5_RSR[,1], b5_RSR[,2])
lines(b7_RSR[,1], b7_RSR[,2])
