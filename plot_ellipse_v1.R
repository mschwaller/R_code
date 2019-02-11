plot_ellipse <- function(t_matrix, colony_phis){
  
  library(rgl)
  
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
 
  plot3d(plot_pts[,1], plot_pts[,2], plot_pts[,3], xlab="phi-1", ylab="phi-2", zlab="phi-3", col="green", type='l', add=TRUE)
  plot3d(colony_phis[,1], colony_phis[,2], colony_phis[,3], col="red", type="s", add=TRUE)
}