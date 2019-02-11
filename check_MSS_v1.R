# ingest R results
from_r <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_R.txt", header=FALSE, skip=0) 
from_sql <- read.csv(file="/Users/mschwall/!Essentials/penguin_stuff/AIST_proposal/MSS_hits_from_sql.txt", header=FALSE, skip=0) 
#from_sql <- toString(unlist(from_sql, recursive=FALSE, use.names=FALSE))
#from_r   <- toString(unlist(from_r, recursive=FALSE, use.names=FALSE))
from_r <- from_r$V1 # turn the data frame factor into a simple character vector
from_sql <- from_sql$V1 # and do the same for this data frame
print(length(which(is.element(from_sql, from_r) == TRUE)))
in_both_sql_and_r <- from_sql[which(is.element(from_sql, from_r) == TRUE)]
in_r_but_not_in_sql <- is.element(from_r, in_both_sql_and_r)
index_of_sql_intersected_with_r_hits <- which(is.element(from_sql, from_r) == TRUE)
index_of_hits_in_r_not_in_sql <- which(is.element(from_r, from_sql[index_of_sql_intersected_with_r_hits]) == FALSE)
r_scene_IDs_not_found_in_sql <- from_r[index_of_hits_in_r_not_in_sql]
print(from_r[r_scene_IDs_not_found_in_sql])
mss_q <- from_r[r_scene_IDs_not_found_in_sql]