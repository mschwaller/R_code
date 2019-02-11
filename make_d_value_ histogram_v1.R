make_histogram <- function(t_matrix, colony_phis){
  
  n_bands <- length(colony_phis[1,])  # number of spherically transformed bands
  pixel_array <- vector(length=(n_bands + 1))  # dimension = # transformed bands + 1
  pixel_array[n_bands + 1] = 1.0      # make the last value of the array = 1
  i_end <- length(colony_phis[,1])  # loop through to i_end
  r_dist <- vector(length=i_end)             # an array of d-values corresponding to each of the colony sample data pixels
  t_invert <- solve(t_matrix)        # calculate the inverse of the transform matrix
  
  for (i in 1:i_end) {
    pixel_array[1:n_bands] = colony_phis[i,] 
    result = t_invert %*% pixel_array                     # t = transpose
    r_dist[i] = t(result[1:n_bands]) %*% result[1:n_bands]   # sum of squares of all bands = d-value
  }
  
  hist(r_dist, main="colony pixel training data", xlab="radial distances (d-values)", breaks=seq(0,1.2,0.02))
  
}