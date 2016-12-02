################################################
# Functions
################################################

# removes NULL and PrivacySuppressed from dataframe
remove_null_and_privsup <- function(col) {
  col[col == "NULL"] = NA
  col[col == "PrivacySuppressed"] = NA
  col
}

keep_row <- function(row) {
  sum(is.na(row)) < 4
}

replace_nas <- function(row) {
  row[is.na(row)] <- col_avgs[is.na(row)]
  row
}