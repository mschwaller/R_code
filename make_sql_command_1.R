t_names <-c("Reese_Adelie_100_1756","Reese_Adelie_100_1757","Reese_Adelie_100_1758","Reese_Adelie_100_1759","Reese_Adelie_100_1760","Reese_Adelie_100_1761","Reese_Adelie_100_1762","Reese_Adelie_100_1779","Reese_Adelie_100_1780","Reese_Adelie_100_1781","Reese_Adelie_100_1782","Reese_Adelie_100_1849","Reese_Adelie_100_1850","Reese_Adelie_100_1851","Reese_Adelie_100_1852","Reese_Adelie_100_1853","Reese_Adelie_100_1854")
num_names = length(t_names)
t_lines <- c("Id INTEGER PRIMARY KEY AUTOINCREMENT,", "wavelength DOUBLE,", "reflectance DOUBLE,", "direct_transmittance DOUBLE,", "diffuse_transmittance DOUBLE)")
for (ii in 1:num_names) {
  
  print(paste("CREATE TABLE", t_names[ii], "(", sep=" "))
  print(t_lines[1])
  print(t_lines[2])
  print(t_lines[3])
  print(t_lines[4])
  print(paste(t_lines[5], ";"))
  print(" ")
}