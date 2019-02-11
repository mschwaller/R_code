# this script calculates the TOA reflectance in Landsdat-8 bands 1-6 (blue, green, red NIR, SWIR1 & SWIR2)
# from ground spectra of Adelie colonies, but also using the relative spectral response curves

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
spectrum_rho_bands <- vector(mode="double", length=6)

# calculate the surface-leaving reflectance for each Landsat-8 band for each guano spectrum
num_guano_spectra <- length(guano_spectra_matrix[1,]) 
for (ispec in 2:num_guano_spectra) { # element 1 in guano_spectra_matrix = wavlengths in nm
  for (ib in 1:6) {
    spectrum_rho_bands[ib] <- sum(guano_spectra_matrix[,ispec] * rsr_matrix[,ib+1]) / rsr_band_integrals[ib]
  }
  print(spectrum_rho_bands)
}