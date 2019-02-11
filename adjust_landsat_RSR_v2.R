# this converts the wavelength in nm to um in the Landsat-8 OLI relative spectral response files

# read in the L8 OLI band RSRs
# nm L7 L4 L5 L8
dir_path <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats"
band1 <- read.csv(file=paste(dir_path, "/band1_RSR_L8_only_rev.txt", sep=""), sep=",", skip=1, header=FALSE)
band2 <- read.csv(file=paste(dir_path, "/band2_RSR_L8_only_rev.txt", sep=""), sep=",", skip=1, header=FALSE)
band3 <- read.csv(file=paste(dir_path, "/band3_RSR_L8_only_rev.txt", sep=""), sep=",", skip=1, header=FALSE)
band4 <- read.csv(file=paste(dir_path, "/band4_RSR_L8_only_rev.txt", sep=""), sep=",", skip=1, header=FALSE)
band5 <- read.csv(file=paste(dir_path, "/band5_RSR_L8_only_SWIR1_rev.txt", sep=""), sep=",", skip=1, header=FALSE)
band7 <- read.csv(file=paste(dir_path, "/band7_RSR_L8_only_SWIR2_rev.txt", sep=""), sep=",", skip=1, header=FALSE)
band1_mat <- as.matrix(band1)
band2_mat <- as.matrix(band2)
band3_mat <- as.matrix(band3)
band4_mat <- as.matrix(band4)
band5_mat <- as.matrix(band5)
band7_mat <- as.matrix(band7)

band1_mat[,1] <- band1_mat[,1] * 0.001
band2_mat[,1] <- band2_mat[,1] * 0.001
band3_mat[,1] <- band3_mat[,1] * 0.001
band4_mat[,1] <- band4_mat[,1] * 0.001
band5_mat[,1] <- band5_mat[,1] * 0.001
band7_mat[,1] <- band7_mat[,1] * 0.001

b_names = c("band1_mat","band2_mat","band3_mat","band4_mat","band5_mat","band7_mat")
f_names = c("/band1_RSR_L8_um.txt","/band2_RSR_L8_um.txt","/band3_RSR_L8_um.txt","/band4_RSR_L8_um.txt","/band5_SWIR1_RSR_L8_um.txt","/band7_SWIR2_RSR_L8_um.txt")
write.table(band1_mat, file=paste(dir_path, "/band1_RSR_L8_um.txt", sep=""), row.names=FALSE, col.names=FALSE, sep=",")
write.table(band2_mat, file=paste(dir_path, "/band2_RSR_L8_um.txt", sep=""), row.names=FALSE, col.names=FALSE, sep=",")
write.table(band3_mat, file=paste(dir_path, "/band3_RSR_L8_um.txt", sep=""), row.names=FALSE, col.names=FALSE, sep=",")
write.table(band4_mat, file=paste(dir_path, "/band4_RSR_L8_um.txt", sep=""), row.names=FALSE, col.names=FALSE, sep=",")
write.table(band5_mat, file=paste(dir_path, "/band5_SWIR1_RSR_L8_um.txt", sep=""), row.names=FALSE, col.names=FALSE, sep=",")
write.table(band7_mat, file=paste(dir_path, "/band7_SWIR2_RSR_L8_um.txt", sep=""), row.names=FALSE, col.names=FALSE, sep=",")
