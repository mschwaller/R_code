# this script plots the petrel guano spectra

# read in the guano spectra
guano_spectra <- read.csv(file="//Users/mschwall/!Essentials/penguin_stuff/petrel_spectra/petrel_reflectance_measurements/R01..txt", header=FALSE, sep=",", skip=0)

# put the guano spectra into a matrix
guano_spectra_matrix <- as.matrix(guano_spectra)
plot(guano_spectra_matrix[,1], guano_spectra_matrix[,2], type="l", xlab="wavelength nm", ylab="reflectance", ylim=c(0,0.9))
num_cols <- length(guano_spectra_matrix[1,]) # number of cols, 1st col is wavelengths
# start plotting the 3rd column of spectra
for (ii in 3:num_cols) {
  # par(new=TRUE)
  # plot(guano_spectra_matrix[,1], guano_spectra_matrix[,ii], type="l", xlab="", ylab="", axes=FALSE)
  lines(guano_spectra_matrix[,1], guano_spectra_matrix[,ii])
}
