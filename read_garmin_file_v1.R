library(fitdc)

fit_name <- "/Users/mschwall/Downloads/mschwall.2019-01-03-02-59-56-535Z.GarminPush.28520478674.fit"
wed_run <- read_fit(fit_name)

## Filter out the record messages:

is_record <- function(mesg) mesg$name == "record"
records <- Filter(is_record, wed_run)

format_record <- function(record) {
  out <- record$fields
  names(out) <- paste(names(out), record$units, sep = ".")
  out
}

records <- lapply(records, format_record)

## Some records have missing fields:

colnames_full <- names(records[[which.max(lengths(records))]])
empty <- setNames(
  as.list(rep(NA, length(colnames_full))),
  colnames_full)

merge_lists <- function(ls_part, ls_full) {
  extra <- setdiff(names(ls_full), names(ls_part))
  append(ls_part, ls_full[extra])[names(ls_full)]  # order as well
}

records <- lapply(records, merge_lists, empty)
records <- data.frame(
  do.call(rbind, records))

bpm_vector <- unlist(records$heart_rate.bpm)
max_x <- ceiling(max(bpm_vector)*.1)*10
min_x <- floor(min(bpm_vector)*.1)*10
borders <- seq(min_x, max_x, 1)

hist(bpm_vector, breaks=borders)
