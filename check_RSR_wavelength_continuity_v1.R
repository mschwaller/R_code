# this script checks the RSR continutity to be sure that the data are in 1 nm steps. If that's not the case
# interpolated values are added

cat("***STARTING*** \n")

# read in the Landsat 8 band 1 Relative Spectral Response from file Ball_BA_RSR.xlsx (find it on the web)
b1_RSR <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band7_RSR_L8_only_SWIR2.txt", header=FALSE, sep=",", skip=2)
out_filename <- "/Users/mschwall/!Essentials/penguin_stuff/t_matrix_from_ground_spectra/RSR_data_all_Landsats/band7_RSR_L8_only_SWIR2_rev.txt"
b1_matrix = matrix(ncol=2,nrow=length(b1_RSR[,1])) # and add it to a matrix, col1=wavelengths, col2=RSRs
b1_matrix[,1]=b1_RSR[,1]
b1_matrix[,2]=b1_RSR[,2]

num_rows <- length(b1_matrix[,1])
cat("wavelength, RSR \n", file=out_filename)

min_wavelength <- b1_matrix[1]
max_wavelength <- b1_matrix[length(b1_matrix[,1]),1]

for (iw in 350:(min_wavelength-1)) {
  cat(sprintf("%s,%s \n", toString(iw), "0.0"), file=out_filename, append=TRUE)
}

found_hole <- FALSE
for (ir in 1:(num_rows-1)) {
  old_wave <- b1_matrix[ir,1] # then continue adding to it
  next_wave <- b1_matrix[ir+1,1]
  if ((ir+2) < num_rows) {third_wave <- b1_matrix[ir+2,1]}
  if ((old_wave + 1) != next_wave) {
    add_wave <- old_wave + 1
    add_rho <- (b1_matrix[ir,2] + b1_matrix[ir+1,2]) / 2
    if (add_rho < 0) {add_rho <- 0}
    if (b1_matrix[ir,2] <0 ) {b1_matrix[ir,2] <- 0}
    found_hole <- TRUE
    print(c("original record: ", b1_matrix[ir,1], "  ", b1_matrix[ir,2]))
    print(c(toString(add_wave), "  ", toString(add_rho)))
    cat(sprintf("%s,%s \n", toString(b1_matrix[ir,1]), toString(b1_matrix[ir,2])), file=out_filename, append=TRUE)
    cat(sprintf("%s,%s \n", toString(add_wave), toString(add_rho)), file=out_filename, append=TRUE)
  }
  else {
    if (b1_matrix[ir,2] <0 ) {b1_matrix[ir,2] <- 0}
    # print(c(b1_matrix[ir,1], "  ", b1_matrix[ir,2]))
    cat(sprintf("%s,%s \n", toString(b1_matrix[ir,1]), toString(b1_matrix[ir,2])), file=out_filename, append=TRUE)
  }
}

# write the last line
cat(sprintf("%s,%s \n", toString(b1_matrix[num_rows,1]), toString(b1_matrix[num_rows,2])), file=out_filename, append=TRUE)


for (iw in (max_wavelength+1):2500) {
  cat(sprintf("%s,%s \n", toString(iw), "0.0"), file=out_filename, append=TRUE)
}

if (found_hole == FALSE) {print("did not find any missing wavelengths")}

cat("***DONE***")