# opens a Garmin activity and pulls out the cadence info
library(stringr)

#full_doc <- readLines("/Users/mschwall/Desktop/cadence/activity_3055515473.xml") # Sept 30
#full_doc <- readLines("/Users/mschwall/Desktop/cadence/activity_3062871955.xml") # Oct 3
#full_doc <- readLines("/Users/mschwall/Desktop/cadence/activity_3080191397.xml") # Oct 10
full_doc <- readLines("/Users/mschwall/Desktop/cadence/activity_3097431466.xml") # Oct 17

cadence_index <- grep("Cadence", full_doc)
num_hits <- length(cadence_index)
all_cadences <- vector(mode="numeric", length=num_hits)
for (ic in 1:num_hits) {
  a_line <- full_doc[cadence_index[ic]]
  c_start <- str_locate(a_line, ">")[1]
  c_end <- str_locate(a_line, "</")[1]
  cadence <- str_sub(a_line, c_start+1, c_end-1)
  cadence <- as.numeric(cadence)
  all_cadences[ic] <- cadence
  # print(cadence)
}
hist(all_cadences, xlab="cadence", main="", breaks=(seq(0,120,5)))
print("mean cadence:")
print(mean(all_cadences[which(all_cadences>0)]))
print("median cadence")
print(median(all_cadences[which(all_cadences>0)]))