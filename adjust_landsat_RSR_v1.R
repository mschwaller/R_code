# this converts the wavelength in nm to um in the Landsat-8 OLI relative spectral response files

# read in the L8 OLI band RSRs
# nm L7 L4 L5 L8
band1 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band1_RSR_L8_only_rev.txt", sep=",", skip=1, header=FALSE)
band2 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band2_RSR_L8_only_rev.txt", sep=",", skip=1, header=FALSE)
band3 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band3_RSR_L8_only_rev.txt", sep=",", skip=1, header=FALSE)
band4 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band4_RSR_L8_only_rev.txt", sep=",", skip=1, header=FALSE)
band5 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band5_RSR_L8_only_SWIR1_rev.txt", sep=",", skip=1, header=FALSE)
band7 <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band7_RSR_L8_only_SWIR2_rev.txt", sep=",", skip=1, header=FALSE)
band1_mat <- as.matrix(band1)
band2_mat <- as.matrix(band2)
band3_mat <- as.matrix(band3)
band4_mat <- as.matrix(band4)
band5_mat <- as.matrix(band5)
band7_mat <- as.matrix(band7)

band1_mat <- band1_mat[,1] * 0.001
band2_mat <- band1_mat[,1] * 0.001
band3_mat <- band1_mat[,1] * 0.001
band4_mat <- band1_mat[,1] * 0.001
band5_mat <- band1_mat[,1] * 0.001
band7_mat <- band1_mat[,1] * 0.001