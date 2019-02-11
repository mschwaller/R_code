
# this is the "main" procedure that does the t-matrix optimization on a demonstration set of training pixels, to validate  
# that the results obtained by this R code matches the results previously obtained using ENVI. The ENVI results were 
# based on the calculation of phi's using a TOA pixel band order of 6, 4, 5, 2, 1, 3 which was found to provide the
# best results when tested against all permutations of all combinations of sets of 4, 5 and 6 bands. When 
# running this code "from scratch" on a new set of training pixels is is recommended that the full set of band
# combinations and permutations be run. The band order resulting in the lowest value of t_fun will be the best
# for separating penguin colony pixels from non-colony pixels

library(optimization)

#################################### configurable parameters ############################################
# ingest the L4,5,7,8 colony training data from a file
colony_roi_frame <- read.delim("/Users/mschwall/!Essentials/penguin_stuff/t-matrix_algorithm_description_ADD/L4578_reformatted_combined_ROIs/L4578_all_colony_ROIs_reformatted_v7.txt", header=TRUE, sep="|", dec=".")
general_roi_frame <- read.delim("/Users/mschwall/!Essentials/penguin_stuff/t-matrix_algorithm_description_ADD/L4578_reformatted_combined_ROIs/L4578_all_general_ROIs_reformatted_v2exp.txt", header=TRUE, sep="|", dec=".")

# calculate the spherical coordinate transformation of the colony pixels using this band order: 6, 4, 5, 2, 1, 3
# where blue=1, green=2, red=3, NIR=4, SWIR1=5, SWIR2=6
band_order = c(6, 4, 5, 2, 1, 3)

# number of times to re-try the simplex optimization, sometimes 1 re-try is enough
num_retries = 1
# num_retries = 4
#################################### configurable parameters ############################################

# used to count the number of times t_fun is called
iteration_counter = 0

# store the 6 blue, green, red IR, SWIR-1, SWIR-2 TOA band reflectances into a matrix for the colony training pixels
TOA_colony_matrix <- as.matrix(colony_roi_frame[,11:16]) # the bands we want happen to fall in fields 11-16 of each pixel record
# and also for the training pixels from rock, soils, ice, water and so forth
TOA_general_matrix <- as.matrix(general_roi_frame[,11:16])

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

# do the same for the general training pixels
general_phis <- matrix(ncol=num_bands-1, nrow=length(TOA_general_matrix[,1]))
general_phis[,1] <- atan(TOA_general_matrix[,band_order[1]] / TOA_general_matrix[,band_order[2]])
g_ssqs <- TOA_general_matrix[,band_order[1]] ^ 2 # square the 1st band value
for (ic in 2:num_bands-1) {
  g_ssqs <- g_ssqs + TOA_general_matrix[,band_order[ic]] ^ 2 # then continue adding to it
  general_phis[,ic] <- atan(sqrt(g_ssqs) / TOA_general_matrix[,band_order[ic+1]])
}
rm(g_ssqs) # no need to carry this forward either

num_transformed_bands = num_bands - 1

# build the affine translation matrix TT, Equation 6
TT <- diag(num_transformed_bands + 1)
TT[1:num_transformed_bands, num_transformed_bands+1] <- colMeans(colony_phis)

# and the rotation matrix TR, Equation 7
TR <- matrix(0, ncol = num_transformed_bands+1, nrow = num_transformed_bands+1) # fill the matrix with 0's
TR[num_transformed_bands+1, num_transformed_bands+1] <- 1 # put a 1 in the bottom right corner of the matrix
TOA_covariance_matrix = cov(colony_phis) # calculate the covariance matrix
evs <- eigen(TOA_covariance_matrix) # calculate the eigenvectors and eigenvalues
TR[1:num_transformed_bands,1:num_transformed_bands] <- t(evs$vectors) # drop the eigenvector matrix into TR in the appropriate spot

# and build the scale matrix TS, but fill it only with the eigenvalues (lambdas), Equation 8
# the simplex routine will add, adjust & optimize TS's scale values
TS <- sqrt(diag(c(evs$values,1))) # add the element=1 to the end of the eigenvalue vector

# for debugging
# t_matrix <- TT %*% t(TS %*% TR)
# t_invert <- solve (t_matrix)
# u_vector <- c(colony_phis[1,], 1.0)
# result <- t_invert %*% u_vector
# print("the A-vector, its last element should be = 1: ")
# result

# we need to start with an inital guess at the scale factors, so we set them all = 1
scale_factors <- vector(mode="numeric", length=num_transformed_bands)
scale_factors[] <- 1.0 

# optim_nm does the simplex optimization of the scale factos in the scale matrix TS, Equation 8
# optim_nm calls t_fun which is a function that calculates that classification accuracy as measured by Kendal's tau;
# it is this classification accuracy that we want to maximize using optim_nm
# optim_nm returns the new scale_factors that provide the "best" classification of colony and non-colony pixels for the
# training set stored in TOA_colony_matrix and TOA_general_matrix
# we iterate by num_retries (a configurale parameter) to re-set the simplex in case it gets hung up on a local minimum before coverging 
for (ii in 1:num_retries) {
  optim_results <- optim_nm(t_fun2, k = num_transformed_bands, start = scale_factors)
  # optim_nm returns a list or some kind of data structure, we just want the scale_factors parameters: the $par part
  scale_factors = optim_results$par 
}

# print the final t-matrix
TSS = TS
TSS[1:num_transformed_bands, 1:num_transformed_bands] <- TSS[1:num_transformed_bands, 1:num_transformed_bands] * scale_factors

# calculate the composite t-matrix using the new sfacs (t = matrix transpose)
t_matrix <- TT %*% t(TSS %*% TR)
print("the final t-matrix:")
print(toString(t_matrix))
print("final tau value")
t_fun2(scale_factors)

# make a histogram of the d-values, if any d-values are > 1 it may be advisable to remove their associated 
# pixels from the colony training data and then re-try the optimization to see if you can get a "perfect" classification
# also plot the 1st 3 dimensions of the classification ellipse and the colony samples 
plot_histogram_and_ellipse(t_matrix, colony_phis)
