T# ingest the L4,5,7,8 colony training data from a file
colony_roi_frame <- read.delim("/Users/mschwall/!Essentials/penguin_stuff/t-matrix_algorithm_description_ADD/L4578_reformatted_combined_ROIs/L4578_all_colony_ROIs_reformatted_v7.txt", header=TRUE, sep="|", dec=".")

# store the blue, green, red IR, SWIR-1, SWIR-2 TOA band reflectances into a matrix
TOA_colony_matrix <- as.matrix(colony_roi_frame[,11:16])

num_bands <- ncol(TOA_colony_matrix)

# build the translation matrix TT
TT <- diag(num_bands + 1)
TT[1:num_bands, num_bands+1] <- colMeans(TOA_colony_matrix)

# build the rotation matrix TR
TR <- matrix(0, ncol = num_bands+1, nrow = num_bands+1) # fill the matrix with 0's
TR[num_bands+1, num_bands+1] <- 1 # put a 1 in the bottom right corner of the matrix
TOA_covariance_matrix = cov(TOA_colony_matrix) # calculate the covariance matrix
evs <- eigen(TOA_covariance_matrix) # calculate the eigenvectors and eigenvalues
TR[1:num_bands,1:num_bands] <- evs$vectors # drop the eigenvector matrix into TR in the appropriate spot

# build the scale matrix TS, but fill it only with the eigenvalues (lambdas)
# the simplex routine will add, adjust & optimize TS's scale values
TS <- diag(c(evs$values,1)) # add the element=1 to the end of the eigenvalue vector