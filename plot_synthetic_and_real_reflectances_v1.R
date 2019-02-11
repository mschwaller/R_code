
# this proc ingests the sample L8 TOA reflectances (ROIs) and the synthetic L8 surface-leaving reflectances
# calculated from the Rees spectra, and plots the polar coordinate transform spectra of both

library(rgl)

#################################### configurable parameters ############################################

# calculate the spherical coordinate transformation of the colony pixels using this band order: 6, 4, 5, 2, 1, 3
# where blue=1, green=2, red=3, NIR=4, SWIR1=5, SWIR2=6
band_order = c(6, 4, 5, 2, 1, 3)

#################################### configurable parameters ############################################

################################# read in the L8 TOA reflectances #######################################

# store the 6 blue, green, red IR, SWIR-1, SWIR-2 TOA band reflectances into a matrix for the colony training pixels
colony_roi_frame <- read.delim("/Users/mschwall/!Essentials/penguin_stuff/t-matrix_algorithm_description_ADD/L4578_reformatted_combined_ROIs/L4578_all_colony_ROIs_reformatted_v7.txt", header=TRUE, sep="|", dec=".")
TOA_colony_matrix <- as.matrix(colony_roi_frame[,11:16]) # the bands we want happen to fall in fields 11-16 of each pixel record

# count the number of TOA reflectance bands that were input 
num_bands <- ncol(TOA_colony_matrix)

# note that the number of phi's (spherical coordinate bands) IS ONE LESS than num_bands
colony_phis <- matrix(ncol=num_bands-1, nrow=length(TOA_colony_matrix[,1]))
# calculate the 1st phi = atan(band6 / band4) see Equation 17 in the Algorithm Description Document
colony_phis[,1] <- atan(TOA_colony_matrix[,band_order[1]] / TOA_colony_matrix[,band_order[2]])
# then calculate each subsequent phi, see Equations 18 - 22 in the ADD
c_ssqs <- TOA_colony_matrix[,band_order[1]] ^ 2 # square the 1st band value
for (ic in 2:(num_bands-1)) {
  c_ssqs <- c_ssqs + TOA_colony_matrix[,band_order[ic]] ^ 2 # then continue adding to it
  colony_phis[,ic] <- atan(sqrt(c_ssqs) / TOA_colony_matrix[,band_order[ic+1]])
}
rm(c_ssqs) # no need to carry this forward

################################# read in the L8 TOA reflectances #######################################


#################### read in the Rees spectra and calculate the synthetic reflectances ##################

# read in the guano spectra
guano_spectra <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/Rees_penguin_guano_data_selected_by_photo_v2.csv", header=FALSE, sep=",", skip=10)

# put the guano spectra into a matrix
guano_spectra_matrix <- as.matrix(guano_spectra)

# read in the RSR spectra
rsr_spectra <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/all_RSRs.txt", header=FALSE, sep=",", skip=1)

# put the guano spectra into a matrix
rsr_matrix <- as.matrix(rsr_spectra)

# calculate the integral of each band's RSR
rsr_band_integrals <- vector(mode="double", length=6)
for (ir in 1:6) {rsr_band_integrals[ir] <- sum(rsr_matrix[,(ir+1)])}

# save a given spectrum's 6 Landsat band reflectanace values here
num_guano_spectra <- length(guano_spectra_matrix[1,]) 
synthetic_rhos <- matrix(ncol=num_bands, nrow=num_guano_spectra)

# calculate the surface-leaving reflectance for each Landsat-8 band for each guano spectrum
for (ispec in 2:num_guano_spectra) { # element 1 in guano_spectra_matrix = wavlengths in nm
  for (ib in 1:6) {
    synthetic_rhos[ispec, ib] <- sum(guano_spectra_matrix[,ispec] * rsr_matrix[,ib+1]) / rsr_band_integrals[ib]
  }
}

synthetic_phis <- matrix(ncol=(num_bands-1), nrow=num_guano_spectra)
# calculate the 1st phi = atan(band6 / band4) see Equation 17 in the Algorithm Description Document
synthetic_phis[,1] <- atan(synthetic_rhos[,band_order[1]] / synthetic_rhos[,band_order[2]])
# then calculate each subsequent phi, see Equations 18 - 22 in the ADD
c_ssqs <- synthetic_rhos[,band_order[1]] ^ 2 # square the 1st band value
for (ic in 1:(num_bands-1)) {
  c_ssqs <- c_ssqs + synthetic_rhos[,band_order[ic]] ^ 2 # then continue adding to it
  synthetic_phis[,ic] <- atan(sqrt(c_ssqs) / synthetic_rhos[,band_order[ic+1]])
}
rm(c_ssqs) # no need to carry this forward

#################### read in the Rees spectra and calculate the synthetic reflectances ##################

rgl.open() # open a rgl device for this plot
rgl.bg(color = "white") # setup the background color
# plot the colony points
plot3d(colony_phis[,1], colony_phis[,2], colony_phis[,3], xlab="phi-1", ylab="phi-2", zlab="phi-3", col="red", type="s")
# and the synthetic points
plot3d(synthetic_phis[,1], synthetic_phis[,2], synthetic_phis[,3], col="blue", type="s", add=TRUE)


