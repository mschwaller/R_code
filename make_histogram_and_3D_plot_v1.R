plot_histogram_and_ellipse <- function(t_matrix, colony_phis){
  
  library(rgl)
  
  # this part generates a histogram of the d-values associated with the colony pixels
  
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
  
  # plot the histogram
  hist(r_dist, main="colony pixel training data", xlab="radial distances (d-values)", breaks=seq(0,1.2,0.02))
  
  # this part plots the 1st 3 dimensions of the classification ellipse and the colony samples
  
  # generate the points that map to the surface of the unit sphere
  n_az_points <- 20
  n_el_points <- 20
  phi <- pi * (seq(0, n_el_points -1, 1)/ (n_el_points - 1))          # 0 <= phi = pi
  theta <- 2.0 * pi * (seq(0, n_az_points -1, 1)/ (n_az_points - 1))  # 0 <= theta <= 2*pi
  
  m = length(t_matrix[,1]) - 1 # m = number of data dimensions in the t_matrix
  
  # now generate the points that plot the transformed ellipsoid
  plot_pts <- matrix(0, nrow=(n_az_points*n_el_points), ncol=3) 
  a_sphere <- vector(length=(m+1))                      # T has m+1 rows & cols
  a_sphere[m+1] <- 1.0
  
  n_ctr <- 0
  for (i in 1:(n_el_points)) {
    for (j in 1:(n_az_points)) {               # use the parametric equation for a sphere
      a_sphere[1] <- cos(theta[j]) * sin(phi[i]) # x coordinate
      a_sphere[2] <- sin(theta[j]) * sin(phi[i]) # y coordinate
      a_sphere[3] <- cos(phi[i])                 # z coordinate
      result <- t_matrix %*% a_sphere # (t = translate) use the t_matrix to convert the unit sphere into
      plot_pts[n_ctr,1] <- result[1]     # the desired ellipsoid
      plot_pts[n_ctr,2] <- result[2]     # plot the 1st 3 dimensions   
      plot_pts[n_ctr,3] <- result[3]
      n_ctr = n_ctr+1
    }
  }
  
  # a few basic rgl commands here to plot the ellipse and points, definitely room for esthetic improvements!
  rgl.open() # open a rgl device for this plot
  rgl.bg(color = "white") # setup the background color
  # plot the 1st 3 dimensions of the ellipse
  plot3d(plot_pts[,1], plot_pts[,2], plot_pts[,3], xlab="phi-1", ylab="phi-2", zlab="phi-3", col="green", type='l')
  # add the colony points
  plot3d(colony_phis[,1], colony_phis[,2], colony_phis[,3], col="red", type="s", add=TRUE)

}