#read csv
rpy3yr <- read.csv("../../data/cleaned_data/rpy3yr_tbl.csv",row.names = 1)
rpy3yr_test <- read.csv("../../data/cleaned_data/rpy3yr_test.csv",row.names = 1)
rpy3yr_train <- read.csv("../../data/cleaned_data/rpy3yr_train.csv",row.names = 1)
#convert them to matrix
rpy3yr <- as.matrix(rpy3yr)
rpy3yr_test <- as.matrix(rpy3yr_test)
rpy3yr_train <- as.matrix(rpy3yr_train)

# Predictors and Response variables
rpy3yr_x <- rpy3yr[,c(2:11)]
rpy3yr_y <- rpy3yr[,1]

rpy3yr_test_x <- rpy3yr_test[,c(2:11)]
rpy3yr_test_y <- rpy3yr_test[,1]

rpy3yr_train_x <- rpy3yr_train[,c(2:11)]
rpy3yr_train_y <- rpy3yr_train[,1]

col_avgs = apply(rpy3yr_x, 2, mean, na.rm=TRUE)

rows_to_keep_train <- array(apply(rpy3yr_train_x, 1, keep_row)) & complete.cases(rpy3yr_train_y)
rows_to_keep_test <- array(complete.cases(rpy3yr_test_y))

rpy3yr_train_x <- rpy3yr_train[rows_to_keep_train,c(2:8)]
rpy3yr_train_y <- rpy3yr_train[rows_to_keep_train,1]

rpy3yr_test_x <- rpy3yr_test[rows_to_keep_test,c(2:8)]
rpy3yr_test_y <- rpy3yr_test[rows_to_keep_test,1]

# Interpolate missing values
rpy3yr_train_x <- t(apply(rpy3yr_train_x, 1, replace_nas))
rpy3yr_test_x <- t(apply(rpy3yr_test_x, 1, replace_nas))

write.csv()
