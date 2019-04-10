# read in the aeronet obervations over McMurdo
# Landsat local crossing time at McMurdo is around 20 GMT

library(stringr)

# read in the McMurdo AERONET data
full_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/Aeronet_AOD_McMurdo_Jan1015_Dec2016/20161201_20161231_ARM_McMurdo.lev20.txt",
                       header=TRUE, skip=6, stringsAsFactors=FALSE)
dec_frame <- full_frame[,c(2,3,6,7,10,19,22,25,26,27,65,66,67,68,69,77,78)]
unique_days <- unique(dec_frame$Day_of_Year)
num_days <- length(unique_days)
obs_hour <- as.numeric(str_sub(dec_frame$Time.hh.mm.ss., start=1, end=2))

# the 0.018 limit was chosen based on a look at the data, see aeronet_to_DART_notes_v1
landsat_crossing_vec <- which(obs_hour >= 19 & obs_hour <= 21 & dec_frame$AOD_675nm < 0.018)

print(paste(dec_frame$Time.hh.mm.ss.[landsat_crossing_vec], dec_frame$Day_of_Year[landsat_crossing_vec],dec_frame$AOD_340nm[landsat_crossing_vec],dec_frame$AOD_380nm[landsat_crossing_vec],dec_frame$AOD_440nm[landsat_crossing_vec],dec_frame$AOD_500nm[landsat_crossing_vec],
            dec_frame$AOD_675nm[landsat_crossing_vec],dec_frame$AOD_870nm[landsat_crossing_vec],dec_frame$AOD_1020nm[landsat_crossing_vec], sep=","))

all_y <- cbind(dec_frame$AOD_340nm[landsat_crossing_vec],dec_frame$AOD_380nm[landsat_crossing_vec],dec_frame$AOD_440nm[landsat_crossing_vec],dec_frame$AOD_500nm[landsat_crossing_vec],
        dec_frame$AOD_675nm[landsat_crossing_vec],dec_frame$AOD_870nm[landsat_crossing_vec],dec_frame$AOD_1020nm[landsat_crossing_vec])

# create plot frame
# plot(NULL, xlim=c(0, ncol(all_y)), ylim=c(0, max(all_y,na.rm=T)), xaxt='n', ylab='AOD', xlab='wavelength nm', main='AERONET/ARM AOD (McMurdo)')
plot(NULL, xlim=c(0, ncol(all_y)), ylim=c(0,0.08), xaxt='n', ylab='AOD', xlab='wavelength nm', main='AERONET/ARM AOD (McMurdo)')
# add x-axis labels in the order of all_y: 340 to 1020 nm
x_labels <- c('340', '380', '440', '500', '675', '870', '1020' )
axis(1, at = 1:length(x_labels), labels = x_labels, las=3)

x <- 1:ncol(all_y)
istop <- nrow(all_y)
for (ir in 1:istop) {
 # if (all_y[ir,5] > 0.018) {
  #  next() }
  lines(x, all_y[ir,])
  points(x, all_y[ir,])
}

AOD340 <- mean(dec_frame$AOD_340nm[landsat_crossing_vec])
AOD380 <- mean(dec_frame$AOD_380nm[landsat_crossing_vec])
AOD440 <- mean(dec_frame$AOD_440nm[landsat_crossing_vec])
AOD500 <- mean(dec_frame$AOD_500nm[landsat_crossing_vec])
AOD675 <- mean(dec_frame$AOD_675nm[landsat_crossing_vec])
AOD870 <- mean(dec_frame$AOD_870nm[landsat_crossing_vec])
AOD1020 <- mean(dec_frame$AOD_1020nm[landsat_crossing_vec])

print(paste("average AOD at 340 nm", AOD340))
print(paste("average AOD at 380 nm", AOD380))
print(paste("average AOD at 440 nm", AOD440))
print(paste("average AOD at 500 nm", AOD500))
print(paste("average AOD at 675 nm", AOD675))
print(paste("average AOD at 870 nm", AOD870))
print(paste("average AOD at 1020 nm", AOD1020))

# calculate AOD at wavelengths from 350 to 2000 nm (.350 to 2 um)
beta340_380 <- log(AOD340/AOD380)/log(380/340)
beta380_440 <- log(AOD380/AOD440)/log(440/380)
beta440_500 <- log(AOD440/AOD500)/log(500/440)
beta500_675 <- log(AOD500/AOD675)/log(675/500)
beta675_870 <- log(AOD675/AOD870)/log(870/675)
beta870_1020 <- log(AOD870/AOD1020)/log(1020/870)

# read in the csv version of the DART subarcticsum_tropov50_aAOD table
AOD_frame <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/subarcticsum_tropov50_aAOD.txt",
                       header=TRUE, stringsAsFactors=FALSE)
num_AODs <- length(AOD_frame$wavelength)

new_DART_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/mcmurdo_new_DART_AOD_v1.txt"

# loop through the full AOD frame, sustitute computed values of AOD for McMurdo into the frame or 9.999 if the wavelength is too big or too small
for (ia in 1:num_AODs) {
  if (AOD_frame$wavelength[ia] >= 0.340 & AOD_frame$wavelength[ia] <= 0.380){ # the DART wavelengths are in um
    this_AOD <- exp(log(AOD340) - log(AOD_frame$wavelength[ia] * 1000 / 340) * beta340_380) # convert um to nm
    print(paste(AOD_frame$wavelength[ia], this_AOD, sep=','))
    AOD_frame$opt_depth[ia] <- this_AOD
  }
  
  if (AOD_frame$wavelength[ia] >= 0.381 & AOD_frame$wavelength[ia] <= 0.440){ # the DART wavelengths are in um
    this_AOD <- exp(log(AOD380) - log(AOD_frame$wavelength[ia] * 1000 / 380) * beta380_440) # convert um to nm
    print(paste(AOD_frame$wavelength[ia], this_AOD, sep=','))
    AOD_frame$opt_depth[ia] <- this_AOD
  }

  if (AOD_frame$wavelength[ia] >= 0.441 & AOD_frame$wavelength[ia] <= 0.500){ # the DART wavelengths are in um
    this_AOD <- exp(log(AOD440) - log(AOD_frame$wavelength[ia] * 1000 / 440) * beta440_500) # convert um to nm
    print(paste(AOD_frame$wavelength[ia], this_AOD, sep=','))
    AOD_frame$opt_depth[ia] <- this_AOD
  }

  if (AOD_frame$wavelength[ia] >= 0.501 & AOD_frame$wavelength[ia] <= 0.675){ # the DART wavelengths are in um
    this_AOD <- exp(log(AOD500) - log(AOD_frame$wavelength[ia] * 1000 / 500) * beta500_675) # convert um to nm
    print(paste(AOD_frame$wavelength[ia], this_AOD, sep=','))
    AOD_frame$opt_depth[ia] <- this_AOD
  }

  if (AOD_frame$wavelength[ia] >= 0.676 & AOD_frame$wavelength[ia] <= 0.870){ # the DART wavelengths are in um
    this_AOD <- exp(log(AOD675) - log(AOD_frame$wavelength[ia] * 1000 / 675) * beta675_870) # convert um to nm
    print(paste(AOD_frame$wavelength[ia], this_AOD, sep=','))
    AOD_frame$opt_depth[ia] <- this_AOD
  }

  if (AOD_frame$wavelength[ia] >= 0.871 & AOD_frame$wavelength[ia] <= 2.000){ # the DART wavelengths are in um
    this_AOD <- exp(log(AOD870) - log(AOD_frame$wavelength[ia] * 1000 / 870) * beta870_1020) # convert um to nm
    print(paste(AOD_frame$wavelength[ia], this_AOD, sep=','))
    AOD_frame$opt_depth[ia] <- this_AOD
  }
  
}

write.table(AOD_frame[,2:4], file=new_DART_file_path, sep=",", row.names=FALSE, col.names=FALSE)

# write all AODs into one file
out_file_path <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/mcmurdo_AOD_v1.txt"
#write.table(mss_meta_frame[Landsat_123_index,], file=out_file_path, row.names=FALSE, col.names=TRUE, sep=",")
#write.table(mss_meta_frame[Landsat_45_index,], file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)



print_mat <- matrix(nrow=1, ncol=2)

for (wave in 340:380) {
  this_AOD <- exp(log(AOD340) - log(wave/340) * beta340_380)
  print_mat[1] <- wave * 0.001  # convert wave from nm to um
  print_mat[2] <- this_AOD
  print(paste(wave * 0.001, this_AOD, sep=','))
  if (wave == 340) {
    write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",")
  } else {
    write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
    }
}

for (wave in 381:440) {
  this_AOD <- exp(log(AOD380) - log(wave/380) * beta380_440)
  print_mat[1] <- wave * 0.001  # convert wave from nm to um
  print_mat[2] <- this_AOD
  print(paste(wave * 0.001, this_AOD, sep=','))
  write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
}

for (wave in 441:500) {
  this_AOD <- exp(log(AOD440) - log(wave/440) * beta440_500)
  print_mat[1] <- wave * 0.001  # convert wave from nm to um
  print_mat[2] <- this_AOD
  print(paste(wave * 0.001, this_AOD, sep=','))
  write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
}

for (wave in 501:675) {
  this_AOD <- exp(log(AOD500) - log(wave/500) * beta500_675)
  print_mat[1] <- wave * 0.001  # convert wave from nm to um
  print_mat[2] <- this_AOD
  print(paste(wave * 0.001, this_AOD, sep=','))
  write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
}

for (wave in 676:870) {
  this_AOD <- exp(log(AOD675) - log(wave/675) * beta675_870)
  print_mat[1] <- wave * 0.001  # convert wave from nm to um
  print_mat[2] <- this_AOD
  print(paste(wave * 0.001, this_AOD, sep=','))
  write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
}

for (wave in 871:2000) {
  this_AOD <- exp(log(AOD870) - log(wave/870) * beta870_1020)
  print_mat[1] <- wave * 0.001  # convert wave from nm to um
  print_mat[2] <- this_AOD
  print(paste(wave * 0.001, this_AOD, sep=','))
  write.table(print_mat, file=out_file_path, row.names=FALSE, col.names=FALSE, sep=",", append=TRUE)
}

