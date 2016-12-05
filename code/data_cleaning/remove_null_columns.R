scorecard = read.csv("../../data/raw_data/MERGED2014_15_PP.csv")

source('../functions/functions.R')
clean_data <- as.data.frame(apply(scorecard, 2, remove_null_and_privsup))

keepcols <- apply(clean_data, 2, function(col) {sum(is.na(col)) < dim(clean_data)[1] * 0.99})

scorecard <- scorecard[keepcols]

write.csv(scorecard, file="../../data/raw_data/non_null_cols.csv")
