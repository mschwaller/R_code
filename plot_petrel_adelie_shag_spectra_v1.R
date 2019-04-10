# this script plots example petrel, shag & Adelie guano spectra

# for Savitzky-Golay smoothing:
# n = moving average window with an odd value 
# p = fit a polynomial of p degree to the moving average data points and give the value to the central point
# m = 0 for no derivative, or the first (m=1), second (m=2) or third (m=3) derivatives.

library(signal)
library(Hmisc)

# set up the plot
plot(NULL, xlim=c(400, 2500), ylim=c(0,1.1), lwd=4, ylab='reflectance', xlab='wavelength nm', main='',
     cex.axis=2, cex.lab=2)
box(lwd=2)
minor.tick(nx=5)

# read in the guano spectra
petrel_spectrum <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/petrel_spectra/petrel_reflectance_measurements/R01..txt", header=FALSE, sep=",", skip=0)
shag_spectrum <- read.csv("/Users/mschwall/!Essentials/penguin_stuff/penguin_shag_petrel_spectra/killingbeck1.020318.0004_moc_wpc.txt", sep=',',col.names = c("wavelength", "panel_rho", "sample_rho", "reflectance"))
adelie_spectrum <-  read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/penguin_shag_petrel_spectra/Rees_penguin_guano_data_selected_by_photo_3.txt", header=TRUE, sep=",", skip=0)

# we will drop spectra in this range because of instrument noise
# this subsetting applies to both the Adelie and petrel spectra (bit not the shag)
drop_this <- which(shag_spectrum[,1] > 1810 & shag_spectrum[,1] < 1940)
drop_this <- c(drop_this, which(shag_spectrum[,1] > 2450))
drop_this <- c(drop_this, which(shag_spectrum[,1] < 375))

# plot the shag spectrum
# first convert from percent reflectance to reflectance
shag_spectrum[,4] <- shag_spectrum[,4] * 0.01
# then smooth the spectrum
smooth_shag <- sgolayfilt(shag_spectrum[,4], p = 4, n = 33, m = 0, ts = 1)
smooth_shag[drop_this] <- NA
# lines(shag_spectrum[,1], shag_spectrum[,4], col="green")
lines(shag_spectrum[,1], smooth_shag, col="green", lwd=4)

# we will drop spectra in this range because of instrument noise
# this subsetting applies to both the Adelie and petrel spectra (bit not the shag)
drop_this <- which(petrel_spectrum[,1] > 1810 & petrel_spectrum[,1] < 1920)
drop_this <- c(drop_this, which(petrel_spectrum[,1] > 2450))
drop_this <- c(drop_this, which(petrel_spectrum[,1] < 375))

# plot the petrel spectrum
# but first smooth the spectrum
smooth_petrel <- sgolayfilt(petrel_spectrum[,8], p = 4, n = 33, m = 0, ts = 1)
# then cut out the noisy part where the detectors shift from silicon to GaAs
smooth_petrel[drop_this] <- NA
lines(petrel_spectrum[,1], smooth_petrel, col="blue", lwd=4)

# plot the Adelie spectrum
num_spectra <- length(adelie_spectrum[1,])
# first convert from percent reflectance to reflectance
for (ii in 2:num_spectra) { 
  adelie_spectrum[,ii] <- adelie_spectrum[,ii] * 0.01}
# then convert um to nm
adelie_spectrum[,1] <- adelie_spectrum[,1] * 1000
# then do the smoothing
smooth_adelie <- sgolayfilt(adelie_spectrum[,4], p = 4, n = 33, m = 0, ts = 1)
smooth_adelie[drop_this] <- NA
# then plot
lines(adelie_spectrum[,1], smooth_adelie, col="red", lwd=4)

# ratio of reflectance at 650 nm to 450 nm
adelie_ratio <- adelie_spectrum[301,4]/adelie_spectrum[101,4]
petrel_ratio <- petrel_spectrum[301,8]/petrel_spectrum[101,8]
shag_ratio <- shag_spectrum[219,4]/shag_spectrum[76,4]
print("adelie, petrel, shag ratio of spectral reflectancec at 650 to 450")
print(paste(adelie_ratio, petrel_ratio, shag_ratio))

adelie_ratio <- adelie_spectrum[301,4]/adelie_spectrum[151,4]
petrel_ratio <- petrel_spectrum[301,8]/petrel_spectrum[151,8]
shag_ratio <- shag_spectrum[219,4]/shag_spectrum[110,4]
print("adelie, petrel, shag ratio of spectral reflectancec at 650 to 500")
print(paste(adelie_ratio, petrel_ratio, shag_ratio))