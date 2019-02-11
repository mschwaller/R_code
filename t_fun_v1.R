t_fun <- function(sfacs, tt, tr, ts, colony_sc_matrix, general_sc_matrix){
  # colony_sc_matrix is the matrix of spherically transformed training pixels
  # general_sc_matrix is the matrix of spherically transformed "general" pixels
  # tt, tr, and ts are the 3 affine matrices for translation, rotation and scaling,
  # see Equations 6, 7 & 8 in the algorithm desription document. The matrices
  # tt, tr and ts get calculated in the procedure t_matri_vx.R where x = the version
  # number. Note that the input scaling matrix ts just contains static values,
  # see below.
  
  num_phis <- length(sfacs) # number of bands-1, also = number of phis
  
  # the matrix ts is fixed and equal to a 0-filled matrix with eigenvalues (lambdas) along the
  # diagonal, the matrix tss contains the product of the fixed lambdas and the variable s-factors
  
  tss = ts
  tss[1:num_phis, 1:num_phis] <- ts[1:num_phis, 1:num_phis] * sfacs
  
  # calculate the composite t-matrix using the new sfacs (t = matrix transpose)
  t_matrix <- tt %*% t(tss %*% tr)
  t_invert <- solve(t_matrix)
  
  # maybe there is a way to vectorize this?
  # calculate the number of correctly & incorrectly classified COLONY pixels
  sc_array <- vector(length = num_phis + 1)
  sc_array[num_phis + 1] = 1.0
  i_end = length(colony_sc_matrix[,1]) # number of rows = number of colony training samples
  colony_is_in <- 0
  colony_is_out <- 0
  for (ic in 1:i_end) {
    sc_array[1:num_phis] <- colony_sc_matrix[ic,]
    result <- t_invert %*% sc_array # last element of result should be a 1, see Equations 28 & 29
    r_dist <- sqrt(t(result[1:num_phis]) %*% result[1:num_phis]) # Equation 30, SSQ of the 1st n-1 elements
    if (sqrt(r_dist) <= 1.0) {colony_is_in <- colony_is_in + 1} else {colony_is_out <- colony_is_out + 1}
  }
  
  # calculate the number of correctly & incorrectly classified GENERAL pixels
  i_end = length(general_sc_matrix[,1]) # number of rows = number of general training samples
  general_is_in <- 0
  general_is_out <- 0
  for (ic in 1:i_end) {
    sc_array[1:num_phis] <- general_sc_matrix[ic,] 
    result <- t_invert %*% sc_array # last element of result should be a 1, see Equations 28 & 29
    r_dist <- sqrt(t(result[1:num_phis]) %*% result[1:num_phis]) # Equation 30, SSQ of the 1st n-1 elements
    if (sqrt(r_dist) <= 1.0) {general_is_in <- general_is_in + 1} else {general_is_out <- general_is_out + 1}
  }
  
  # now calculate Kendall's tau, see Equation 10
  x <- general_is_out + colony_is_out # these are the row & column sums of the 2x2 classification matrix
  y <- general_is_in  + colony_is_in
  p <- general_is_out + general_is_in
  q <- colony_is_out  + colony_is_in
  
  if (y == 0) {tau <- 0.0} else {
     tau <- (general_is_out * colony_is_in - general_is_in * colony_is_out) / sqrt(x*y*p*q) }
  # assign some additional penalty for errors of commission & omission, and have the result -> 0 when
  # the optimization is perfect
  tau_factor = (20.0 * colony_is_out + 20.0 * general_is_in) * (1.0 - tau)
  
  print(c("tau: ", toString(tau)))
  print(c("optimization criterion: ", toString(tau_factor)))
  print(c("colony-in & general-in:   ", toString(colony_is_in), toString(general_is_in)))
  print(c("colony-out & general-out: ", toString(colony_is_out), toString(general_is_out)))
  print(" ")
  
  return(tau_factor)
        
}