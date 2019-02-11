t_names <-c("Reese_Adelie_100_1756","Reese_Adelie_100_1757","Reese_Adelie_100_1758","Reese_Adelie_100_1759","Reese_Adelie_100_1760","Reese_Adelie_100_1761","Reese_Adelie_100_1762","Reese_Adelie_100_1779","Reese_Adelie_100_1780","Reese_Adelie_100_1781","Reese_Adelie_100_1782","Reese_Adelie_100_1849","Reese_Adelie_100_1850","Reese_Adelie_100_1851","Reese_Adelie_100_1852","Reese_Adelie_100_1853","Reese_Adelie_100_1854")
num_names = length(t_names)
# t_lines <- c("Id INTEGER PRIMARY KEY AUTOINCREMENT,", "wavelength DOUBLE,", "reflectance DOUBLE,", "direct_transmittance DOUBLE,", "diffuse_reflectance DOUBLE)")
# t_lines <- c("Id INTEGER PRIMARY KEY AUTOINCREMENT,", "wavelength DOUBLE,", "reflectance DOUBLE,", "direct_transmittance DOUBLE,", "diffuse_reflectance DOUBLE)")
for (ii in 1:num_names) {
  
  # print(paste("DELETE FROM", t_names[ii], "WHERE wavelength > 0;", sep=" "))
  print(paste("INSERT INTO", t_names[ii], "(wavelength, reflectance)", sep=" "))
  print(paste("  SELECT wavelength,", t_names[ii], sep=" "))
  print("  FROM rees_spectra;")
  print(paste("UPDATE", t_names[ii], "SET direct_transmittance = 0;", sep=" "))
  print(paste("UPDATE", t_names[ii], "SET diffuse_transmittance = 0;", sep=" "))
  print(paste("UPDATE", t_names[ii], "SET reflectance = 0 WHERE reflectance < 0;"))
  print(paste("UPDATE", t_names[ii], "SET reflectance = 95 WHERE reflectance > 95;"))
  print(" ")
}