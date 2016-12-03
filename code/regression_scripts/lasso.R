library(glmnet)
source("../functions/functions.R")

grid = 10^seq(10, -2, length =100)
set.seed(1)

## lasso regression for rpy 3 yr

#read csv
rpy3yr_train_x <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_train_x.csv",row.names = 1))
rpy3yr_train_y <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_train_y.csv",row.names = 1))
rpy3yr_test_x <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_test_x.csv",row.names = 1))
rpy3yr_test_y <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_test_y.csv",row.names = 1))
rpy3yr_x <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_x.csv",row.names = 1))
rpy3yr_y <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_y.csv",row.names = 1))

rpy3yr_lr_cv_out = cv.glmnet(rpy3yr_train_x,rpy3yr_train_y, alpha = 1, lambda = grid, standardize = FALSE, intercept = FALSE)


# in RR look for $lambda.min from the output of cv.glmnet()
rpy3yr_lr_bestlam=rpy3yr_lr_cv_out$lambda.min


##best fitted lambda on test set to calculate MSE
rpy3yr_lasso <- glmnet(rpy3yr_train_x,rpy3yr_train_y,alpha=1, lambda =grid , intercept = FALSE)
rpy3yr_lasso_pred <- predict(rpy3yr_lasso, s= rpy3yr_lr_bestlam, newx = rpy3yr_test_x)
rpy3yr_lasso_test_mse <- mean((rpy3yr_lasso_pred - rpy3yr_test_y)^2)

#full data
rpy3yr_lasso_out <- glmnet(rpy3yr_x,rpy3yr_y, alpha = 1, intercept = FALSE)
rpy3yr_lasso_full_fit <- predict(rpy3yr_lasso_out, type = "coefficients", s = rpy3yr_lr_bestlam)
rpy3yr_lr_coef <- as.matrix(rpy3yr_lasso_full_fit)


# Plot the cross-validation errors in terms of the tunning parameter to visualize which parameter gives the "best" model:

png(file = "../../images/rpy3yr_lasso_regression.png")
plot(rpy3yr_lr_cv_out)
dev.off()



## lasso regression for CDR3

#read csv
cdr3_train_x <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_train_x.csv",row.names = 1))
cdr3_train_y <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_train_y.csv",row.names = 1))
cdr3_test_x <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_test_x.csv",row.names = 1))
cdr3_test_y <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_test_y.csv",row.names = 1))
cdr3_x <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_x.csv",row.names = 1))
cdr3_y <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_y.csv",row.names = 1))

cdr3_lr_cv_out = cv.glmnet(cdr3_train_x,cdr3_train_y, alpha = 1, lambda = grid, standardize = FALSE, intercept = FALSE)


# in RR look for $lambda.min from the output of cv.glmnet()
cdr3_lr_bestlam=cdr3_lr_cv_out$lambda.min


##best fitted lambda on test set to calculate MSE
cdr3_lasso <- glmnet(cdr3_train_x,cdr3_train_y,alpha=1, lambda =grid , intercept = FALSE)
cdr3_lasso_pred <- predict(cdr3_lasso, s= cdr3_lr_bestlam, newx = cdr3_test_x)
cdr3_lasso_test_mse <- mean((cdr3_lasso_pred - cdr3_test_y)^2)

#full data
cdr3_lasso_out <- glmnet(cdr3_x,cdr3_y, alpha = 1, intercept = FALSE)
cdr3_lasso_full_fit <- predict(cdr3_lasso_out, type = "coefficients", s = cdr3_lr_bestlam)
cdr3_lr_coef <- as.matrix(cdr3_lasso_full_fit)


# Plot the cross-validation errors in terms of the tunning parameter to visualize which parameter gives the "best" model:

png(file = "../../images/cdr3_lasso_regression.png")
plot(cdr3_lr_cv_out)
dev.off()


save(rpy3yr_lr_cv_out, cdr3_lr_cv_out,
     rpy3yr_lr_bestlam, cdr3_lr_bestlam,
     rpy3yr_lasso_test_mse, cdr3_lasso_test_mse,
     rpy3yr_lasso_full_fit, cdr3_lasso_full_fit,
     rpy3yr_lr_coef, cdr3_lr_coef,
     file = "../../data/RData/lasso.RData" )
