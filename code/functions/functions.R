################################################
# Functions
################################################

# removes NULL and PrivacySuppressed from dataframe
remove_null_and_privsup <- function(col) {
  col[col == "NULL"] = NA
  col[col == "PrivacySuppressed"] = NA
  col
}