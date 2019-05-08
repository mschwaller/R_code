
# this proc ingests the sample L8 TOA reflectances (ROIs) and the synthetic L8 surface-leaving reflectances
# calculated from the Rees spectra, and plots the polar coordinate transform spectra of both

library(rgl)

rees_DART_results_filename <- "C:/Users/Schwaller/Desktop/DART/DART_results/DART_results_mcmurdo_atmosphere_R_format_12April2019a.txt"
# note that the DART results below DO NOT use the McMurdo atmosphere
rees_DART_results_filename <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/DART_results/ALL_DART_results_22Feb2019_reformatted.txt"

L8_ROIs_filename <- "C:/Users/Schwaller/Desktop/DART/t_matrix_from_ground_spectra/Landsat_ROIs/L8_colony_ROIs_reformatted_csv.txt"
L8_ROIs_filename <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/Landsat_ROIs/L8_colony_ROIs_reformatted.csv.txt"
sat <- "L8"

rees_spectra_filename <- "C:/Users/Schwaller/Desktop/DART/t_matrix_from_ground_spectra/Rees_penguin_guano_data_selected_by_photo_v2.csv"
rees_spectra_filename <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/Rees_penguin_guano_data_selected_by_photo_v2.csv"

plot_directory <- "C:/Users/Schwaller/Desktop/DART/RSR_reflectance_plots"
plot_directory <- "/Users/mschwall/Desktop/rees_plots"

# read the "DART" RSRs built from band centers and bandwidths assuming a perfect square bandpass
# the bandpasses were found here: https://landsat.usgs.gov/what-are-band-designations-landsat-satellites
rsr_filename <- "C:/Users/Schwaller/Desktop/DART/t_matrix_from_ground_spectra/RSR_Landsat_8/L8_RSRs_for_DART/all_DART_L8_RSRs.txt"
rsr_filename <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_Landsat_8/L8_all_RSRs.txt"

#################################### configurable parameters ############################################

# calculate the spherical coordinate transformation of the colony pixels using this band order: 6, 4, 5, 2, 1, 3
# where blue=1, green=2, red=3, NIR=4, SWIR1=5, SWIR2=6
band_order = c(6, 4, 5, 2, 1, 3)
#band_order = c(2, 3, 4, 1, 5, 6)

#################################### configurable parameters ############################################


################################# read in the Reese DART reflectances #######################################
all_DART_frame <- read.delim(rees_DART_results_filename, header=FALSE, 
                               col.names=c("spectrum","band1", "band2", "band3", "band4", "band5", "band6"), sep=",", dec=".")
record_indicies <- grep("> source", all_DART_frame$spectrum)
only_rees_index <- grep("Rees", all_DART_frame$spectrum)
all_DART_rhos <- as.matrix(all_DART_frame[only_rees_index, 2:7]) # the bands we want happen to fall in fields 11-16 of each pixel record

# and calculate the phis
num_bands <- ncol(all_DART_rhos)
num_DART_spectra <- nrow(all_DART_rhos)
all_DART_phis <- matrix(ncol=(num_bands-1), nrow=num_DART_spectra)
all_DART_phis[,1] <- atan(all_DART_rhos[,band_order[1]] / all_DART_rhos[,band_order[2]])
# then calculate each subsequent phi, see Equations 18 - 22 in the ADD
c_ssqs <- all_DART_rhos[,band_order[1]] ^ 2 # square the 1st band value
for (ic in 2:(num_bands-1)) {
  c_ssqs <- c_ssqs + all_DART_rhos[,band_order[ic]] ^ 2 # then continue adding to it
  all_DART_phis[,ic] <- atan(sqrt(c_ssqs) / all_DART_rhos[,band_order[ic+1]])
}
rm(c_ssqs) # no need to carry this forward


################################# read in the L8 TOA reflectances #######################################

# store the 6 blue, green, red IR, SWIR-1, SWIR-2 TOA band reflectances into a matrix for the colony training pixels
colony_roi_frame <- read.delim(L8_ROIs_filename, header=TRUE, sep=",", dec=".")
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

################################# calculate the RSR matrix ##############################################

rsr_spectra <- read.csv(file=rsr_filename, header=FALSE, sep=",", skip=1)

# put the RSR spectra into a matrix
rsr_matrix <- as.matrix(rsr_spectra)

# calculate the integral of each band's RSR
rsr_band_integrals <- vector(mode="double", length=6)
for (ir in 1:6) {rsr_band_integrals[ir] <- sum(rsr_matrix[,(ir+1)])}

#######################################################################################################


#################### read in the Rees spectra and calculate the synthetic reflectances ##################

# read in the guano spectra
Reese_guano_spectra <- read.csv(file=rees_spectra_filename, header=FALSE, sep=",", skip=10)

# put the guano spectra into a matrix
Reese_guano_spectra_matrix <- as.matrix(Reese_guano_spectra)

# save a given spectrum's 6 Landsat band reflectanace values here
Reese_num_guano_spectra <- length(Reese_guano_spectra_matrix[1,]) 
Reese_synthetic_rhos <- matrix(ncol=num_bands, nrow=Reese_num_guano_spectra)

# calculate the surface-leaving reflectance for each Landsat-8 band for each guano spectrum
for (ispec in 2:Reese_num_guano_spectra) { # element 1 in guano_spectra_matrix = wavlengths in nm
  for (ib in 1:6) {
    Reese_synthetic_rhos[ispec, ib] <- sum(Reese_guano_spectra_matrix[,ispec] * rsr_matrix[,ib+1]) / rsr_band_integrals[ib]
  }
}

Reese_synthetic_phis <- matrix(ncol=(num_bands-1), nrow=Reese_num_guano_spectra)
# calculate the 1st phi = atan(band6 / band4) see Equation 17 in the Algorithm Description Document
Reese_synthetic_phis[,1] <- atan(Reese_synthetic_rhos[,band_order[1]] / Reese_synthetic_rhos[,band_order[2]])
# then calculate each subsequent phi, see Equations 18 - 22 in the ADD
c_ssqs <- Reese_synthetic_rhos[,band_order[1]] ^ 2 # square the 1st band value
for (ic in 2:(num_bands-1)) {
  c_ssqs <- c_ssqs + Reese_synthetic_rhos[,band_order[ic]] ^ 2 # then continue adding to it
  Reese_synthetic_phis[,ic] <- atan(sqrt(c_ssqs) / Reese_synthetic_rhos[,band_order[ic+1]])
}
rm(c_ssqs) # no need to carry this forward


# create a dataframe of phi values from the matrices
Reese_num_synthetic_phi_rows <- length(Reese_synthetic_phis[,1])
Landsat_phi_frame <- data.frame("phi_1"=colony_phis[,1], "phi_2"=colony_phis[,2], "phi_3"=colony_phis[,3], "phi_4"=colony_phis[,4], "phi_5"=colony_phis[,5], 
                       "source"=rep("colony", length(colony_phis[,1])), "color"=rep("red", length(colony_phis[,1])), stringsAsFactors=FALSE)
Reese_phi_frame <- data.frame("phi_1"=Reese_synthetic_phis[2:Reese_num_synthetic_phi_rows,1], "phi_2"=Reese_synthetic_phis[2:Reese_num_synthetic_phi_rows,2], 
                      "phi_3"=Reese_synthetic_phis[2:Reese_num_synthetic_phi_rows,3],
                      "phi_4"=Reese_synthetic_phis[2:Reese_num_synthetic_phi_rows,4], "phi_5"=Reese_synthetic_phis[2:Reese_num_synthetic_phi_rows,5], 
                      "source"=rep("Reese_synthetic", Reese_num_synthetic_phi_rows-1), "color"=rep("blue", Reese_num_synthetic_phi_rows-1), stringsAsFactors=FALSE)
DART_TOA_phi_frame <- data.frame("phi_1"=all_DART_phis[,1], "phi_2"=all_DART_phis[,2], "phi_3"=all_DART_phis[,3], "phi_4"=all_DART_phis[,4], "phi_5"=all_DART_phis[,5], 
                      "source"="REESE_DART_TOA", "color"="black", stringsAsFactors=FALSE)

s_frame <- rbind(Landsat_phi_frame, Reese_phi_frame)
phi_frame <- rbind(s_frame, DART_TOA_phi_frame)

# create a dataframe of rho values from the matrices
num_landsat_rows <- length(colony_roi_frame$X)
num_reese_rows <- length(Reese_synthetic_rhos[,1])
landsat_rho_frame <- data.frame("B1"=TOA_colony_matrix[,1]/10000, "B2"=TOA_colony_matrix[,2]/10000, "B3"=TOA_colony_matrix[,3]/10000, "B4"=TOA_colony_matrix[,4]/10000, 
                                "B5"=TOA_colony_matrix[,5]/10000, "B6"=TOA_colony_matrix[,6]/10000, "source"=rep("Landsat", num_landsat_rows), "color"=rep("red", num_landsat_rows), stringsAsFactors=FALSE)
Reese_rho_frame <- data.frame("B1"=Reese_synthetic_rhos[2:num_reese_rows,1], "B2"=Reese_synthetic_rhos[2:num_reese_rows,2], "B3"=Reese_synthetic_rhos[2:num_reese_rows,3],
                              "B4"=Reese_synthetic_rhos[2:num_reese_rows,4], "B5"=Reese_synthetic_rhos[2:num_reese_rows,5], "B6"=Reese_synthetic_rhos[2:num_reese_rows,6], 
                              "source"=rep("Reese", num_reese_rows-1), "color"=rep("blue", num_reese_rows-1), stringsAsFactors=FALSE)
all_DART_rho_frame <- data.frame("B1"=all_DART_rhos[,1], "B2"=all_DART_rhos[,2], "B3"=all_DART_rhos[,3], "B4"=all_DART_rhos[,4], 
                        "B5"=all_DART_rhos[,5], "B6"=all_DART_rhos[,6], "source"="REESE_DART_TOA", "color"="black", stringsAsFactors=FALSE)

s_frame <- rbind(landsat_rho_frame, Reese_rho_frame)
landsat_rho_frame <- rbind(s_frame, all_DART_rho_frame)


#################### read in the Rees spectra and calculate the synthetic reflectances ##################
r3dDefaults$windowRect <- c(0,50, 800, 800)  # plot to a bigger window than the default
rgl.open() # open a rgl device for this plot
rgl.bg(color = "white") # setup the background color
# plot the colony points
#plot3d(colony_phis[,1], colony_phis[,2], colony_phis[,3], xlab="phi-1", ylab="phi-2", zlab="phi-3", col="red", type="p", alpha=0.5)
# and the synthetic points
# there are 27 rows in the synthetic_phis matrix, the 1st row is bogus (was place-holder for wavelength)
# row 27 corresponds to the test TOA spectrum Reese_Adelie_100_1854
#plot3d(synthetic_phis[2:26,1], synthetic_phis[2:26,2], synthetic_phis[2:26,3], col="blue", type="s", add=TRUE)
#points3d(synthetic_phis[5,1], synthetic_phis[5,2], synthetic_phis[5,3], col="green", type="s", add=TRUE, alpha=1.0)
# plot the point for Reese_adelie_100_1854 in green
#plot3d(synthetic_phis[2:26,1], synthetic_phis[2:26,2], synthetic_phis[2:26,3], xlab="phi-1", ylab="phi-2", zlab="phi-3", col="blue", type="s", add=TRUE)
#plot3d(synthetic_phis[27,1], synthetic_phis[27,2], synthetic_phis[27,3], col="red", type="s", add=TRUE)
plot_these <- which((phi_frame$source == "colony") | (phi_frame$source == "REESE_DART_TOA"))
plot3d(phi_frame$phi_1[plot_these], phi_frame$phi_2[plot_these], phi_frame$phi_3[plot_these], col=phi_frame$color[plot_these], type="p",
       xlim=c(0,2), ylim=c(0,2), zlim=c(0,2), xlab="phi-1", ylab="phi-2", zlab="phi-3")


####################### plot all 2-way band combinations in reflectance space #########################
combis <- cbind(c(6,6,6,6,6,5,5,5,5,4,4,4,3,3,2), c(5,4,3,2,1,4,3,2,1,3,2,1,2,1,1))
for (ip in 1:15) {
  xname <- paste("B", as.character(combis[ip,1]), sep="")
  yname <- paste("B", as.character(combis[ip,2]), sep="")
  file_name <- paste(plot_directory, "/", sat, "_", xname, yname, ".jpg", sep="")
  jpeg(file_name)
  plot(landsat_rho_frame[[xname]],landsat_rho_frame[[yname]], col=landsat_rho_frame$color, xlim=c(0.0,0.6), ylim=c(0.0,0.6),
       xlab=xname, ylab=yname)
  #points(landsat_rho_frame[[xname]][1],landsat_rho_frame[[yname]][1], col="black", pch=19)
  #points(landsat_rho_frame[[xname]][37],landsat_rho_frame[[yname]][37], col="orange", pch=19)
  dev.off()
}

####################### then plot all 2-way band combinations in phi space #########################
combis <- cbind(c(5,5,5,5,4,4,4,3,3,2), c(4,3,2,1,3,2,1,2,1,1))
plot_folder <- plot_directory
for (ip in 1:10) {
  xname <- paste("phi_", as.character(combis[ip,1]), sep="")
  yname <- paste("phi_", as.character(combis[ip,2]), sep="")
  file_name <- paste(plot_folder, "/", sat, "_", xname, yname,".jpg", sep="")
  jpeg(file_name)
  plot(phi_frame[[xname]],phi_frame[[yname]], col=phi_frame$color, xlim=c(0.0, 1.8), ylim=c(0.0, 1.8),
       xlab=xname, ylab=yname)
  #points(landsat_rho_frame[[xname]][1],landsat_rho_frame[[yname]][1], col="black", pch=19)
  #points(landsat_rho_frame[[xname]][37],landsat_rho_frame[[yname]][37], col="orange", pch=19)
  dev.off()
}

print("plots go here:")
print(plot_directory)
print("DONE!")

