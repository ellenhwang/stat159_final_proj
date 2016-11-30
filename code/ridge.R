## Ridge regression for rpy 3 yr

library(glmnet)

#read csv
rpy3yr <- read.csv("../data/cleaned_data/rpy3yr_tbl.csv",row.names = 1)
rpy3yr_test <- read.csv("../data/cleaned_data/rpy3yr_test.csv",row.names = 1)
rpy3yr_train <- read.csv("../data/cleaned_data/rpy3yr_train.csv",row.names = 1)
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


# The output from the fitting function will give you a 
#list of models (from which you will select the "best" model);
#save() this output in a .RData file.
#save(cv.out, file = "")
grid = 10^seq(10,-2,length =100)

#take out missing values
train_cc <- complete.cases(rpy3yr_train_x) & complete.cases(rpy3yr_train_y)
rpy3yr_train_x <- rpy3yr_train[train_cc,c(2:11)]
rpy3yr_train_y <- rpy3yr_train[train_cc,1]

test_cc <- complete.cases(rpy3yr_test_x) & complete.cases(rpy3yr_test_y)
rpy3yr_test_x <- rpy3yr_test[test_cc,c(2:11)]
rpy3yr_test_y <- rpy3yr_test[test_cc,1]

cc <- complete.cases(rpy3yr_x) & complete.cases(rpy3yr_y)
rpy3yr_x <- rpy3yr[cc,c(2:11)]
rpy3yr_y <- rpy3yr[cc,1]



set.seed(1)
rpy3yr_rr_cv_out = cv.glmnet(rpy3yr_train_x,rpy3yr_train_y, alpha = 0, lambda = grid, standardize = FALSE, intercept = FALSE)


# in RR look for $lambda.min from the output of cv.glmnet()
rpy3yr_rr_bestlam=rpy3yr_rr_cv_out$lambda.min


##best fitted lambda on test set to calculate MSE
rpy3yr_ridge <- glmnet(rpy3yr_train_x,rpy3yr_train_y,alpha=0, lambda =grid , intercept = FALSE)
rpy3yr_ridge_pred <- predict(rpy3yr_ridge, s= rpy3yr_rr_bestlam, newx = rpy3yr_test_x)
rpy3yr_ridge_test_mse <- mean((rpy3yr_ridge_pred - rpy3yr_test_y)^2)

#full data
rpy3yr_ridge_out <- glmnet(rpy3yr_x,rpy3yr_y, alpha = 0, intercept = FALSE)
rpy3yr_ridge_full_fit <- predict(rpy3yr_ridge_out, type = "coefficients", s = rpy3yr_rr_bestlam)
rpy3yr_rr_coef <- as.matrix(rpy3yr_ridge_full_fit)


# Plot the cross-validation errors in terms of the tunning parameter to visualize which parameter gives the "best" model:

png(file = "../images/rpy3yr_ridge_regression.png")
plot(rpy3yr_rr_cv_out)
dev.off



## Ridge regression for CDR3


#read csv
cdr3 <- read.csv("../data/cleaned_data/cdr3_tbl.csv",row.names = 1)
cdr3_test <- read.csv("../data/cleaned_data/cdr3_test.csv",row.names = 1)
cdr3_train <- read.csv("../data/cleaned_data/cdr3_train.csv",row.names = 1)
#convert them to matrix
cdr3 <- as.matrix(cdr3)
cdr3_test <- as.matrix(cdr3_test)
cdr3_train <- as.matrix(cdr3_train)

grid = 10^seq(10,-2,length =100)

# Predictors and Response variables
cdr3_x <- cdr3[,c(2:8)]
cdr3_y <- cdr3[,1]

cdr3_test_x <- cdr3_test[,c(2:8)]
cdr3_test_y <- cdr3_test[,1]

cdr3_train_x <- cdr3_train[,c(2:8)]
cdr3_train_y <- cdr3_train[,1]


#take out missing values
cdr3_train_cc <- complete.cases(cdr3_train_x) & complete.cases(cdr3_train_y)
cdr3_train_x <- cdr3_train[cdr3_train_cc,c(2:8)]
cdr3_train_y <- cdr3_train[cdr3_train_cc,1]

cdr3_test_cc <- complete.cases(cdr3_test_x) & complete.cases(cdr3_test_y)
cdr3_test_x <- cdr3_test[cdr3_test_cc,c(2:8)]
cdr3_test_y <- cdr3_test[cdr3_test_cc,1]

cdr3_cc <- complete.cases(cdr3_x) & complete.cases(cdr3_y)
cdr3_x <- cdr3[cdr3_cc,c(2:8)]
cdr3_y <- cdr3[cdr3_cc,1]



set.seed(1)
cdr3_rr_cv_out = cv.glmnet(cdr3_train_x,cdr3_train_y, alpha = 0, lambda = grid, standardize = FALSE, intercept = FALSE)


# in RR look for $lambda.min from the output of cv.glmnet()
cdr3_rr_bestlam=cdr3_rr_cv_out$lambda.min


##best fitted lambda on test set to calculate MSE
cdr3_ridge <- glmnet(cdr3_train_x,cdr3_train_y,alpha=0, lambda =grid , intercept = FALSE)
cdr3_ridge_pred <- predict(cdr3_ridge, s= cdr3_rr_bestlam, newx = cdr3_test_x)
cdr3_ridge_test_mse <- mean((cdr3_ridge_pred - cdr3_test_y)^2)

#full data
cdr3_ridge_out <- glmnet(cdr3_x,cdr3_y, alpha = 0, intercept = FALSE)
cdr3_ridge_full_fit <- predict(cdr3_ridge_out, type = "coefficients", s = cdr3_rr_bestlam)
cdr3_rr_coef <- as.matrix(cdr3_ridge_full_fit)


# Plot the cross-validation errors in terms of the tunning parameter to visualize which parameter gives the "best" model:

png(file = "../images/cdr3_ridge_regression.png")
plot(cdr3_rr_cv_out)
dev.off






save(rpy3yr_rr_cv_out, cdr3_rr_cv_out,
     rpy3yr_rr_bestlam, cdr3_rr_bestlam,
     rpy3yr_ridge_test_mse, cdr3_ridge_test_mse,
     rpy3yr_ridge_full_fit, cdr3_ridge_full_fit,
     rpy3yr_rr_coef, cdr3_rr_coef,
     file = "../data/ridge.RData" )

