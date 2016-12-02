library(glmnet)
source("functions/functions.R")

grid = 10^seq(10, -2, length =100)
set.seed(1)

## Ridge regression for rpy 3 yr

#read csv
rpy3yr_train_x <- as.matrix(read.csv("../data/cleaned_data/rpy3yr_train_x.csv",row.names = 1))
rpy3yr_train_y <- as.matrix(read.csv("../data/cleaned_data/rpy3yr_train_y.csv",row.names = 1))
rpy3yr_test_x <- as.matrix(read.csv("../data/cleaned_data/rpy3yr_test_x.csv",row.names = 1))
rpy3yr_test_y <- as.matrix(read.csv("../data/cleaned_data/rpy3yr_test_y.csv",row.names = 1))


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
dev.off()



## ridge regression for CDR3

#read csv
cdr3_train_x <- as.matrix(read.csv("../data/cleaned_data/cdr3_train_x.csv",row.names = 1))
cdr3_train_y <- as.matrix(read.csv("../data/cleaned_data/cdr3_train_y.csv",row.names = 1))
cdr3_test_x <- as.matrix(read.csv("../data/cleaned_data/cdr3_test_x.csv",row.names = 1))
cdr3_test_y <- as.matrix(read.csv("../data/cleaned_data/cdr3_test_y.csv",row.names = 1))

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
dev.off()


save(rpy3yr_rr_cv_out, cdr3_rr_cv_out,
     rpy3yr_rr_bestlam, cdr3_rr_bestlam,
     rpy3yr_ridge_test_mse, cdr3_ridge_test_mse,
     rpy3yr_ridge_full_fit, cdr3_ridge_full_fit,
     rpy3yr_rr_coef, cdr3_rr_coef,
     file = "../data/ridge.RData" )
