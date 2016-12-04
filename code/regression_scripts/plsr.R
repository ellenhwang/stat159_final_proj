#####################################################
##### Partial Least Squares Regression Analysis #####
#####################################################
# Import library and data
pkg = c("pls", "TSA", "forecast", "astsa")
new.pkg = pkg[!(pkg %in% installed.packages()[,"Package"])]
if (length(new.pkg)) {install.packages(new.pkg,dependencies = TRUE)}
sapply(pkg,require,character.only = TRUE)

# Training data
rpy_xtrain <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_train_x.csv", row.names = 1, stringsAsFactors = FALSE))
rpy_ytrain <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_train_y.csv", row.names = 1, stringsAsFactors = FALSE))
cdr_xtrain <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_train_x.csv", row.names = 1, stringsAsFactors = FALSE))
cdr_ytrain <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_train_y.csv", row.names = 1, stringsAsFactors = FALSE))

# Test data
rpy_xtest <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_test_x.csv", row.names = 1, stringsAsFactors = FALSE))
rpy_ytest <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_test_y.csv", row.names = 1, stringsAsFactors = FALSE))
cdr_xtest <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_test_x.csv", row.names = 1, stringsAsFactors = FALSE))
cdr_ytest <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_test_y.csv", row.names = 1, stringsAsFactors = FALSE))

# Full data
rpy_xfull <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_x.csv", row.names = 1, stringsAsFactors = FALSE))
rpy_yfull <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/rpy3yr_y.csv", row.names = 1, stringsAsFactors = FALSE))
cdr_xfull <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_x.csv", row.names = 1, stringsAsFactors = FALSE))
cdr_yfull <- as.matrix(read.csv("../../data/cleaned_data/NA_removed/cdr3_y.csv", row.names = 1, stringsAsFactors = FALSE))

## PLSR for RPY3YR
set.seed(1234)
# 1) PLSR Fit
rpy_pls_fit = plsr(rpy_ytrain ~ rpy_xtrain, scale = TRUE, validation = "CV")
rpy_opt_comp <- which.min(rpy_pls_fit$validation$PRESS)
print(paste0("By CV, we can conclude that ", rpy_opt_comp, " components should be used."))

# 2) Plot PLSR
png(file = "../../images/rpy3yr_plsr_validation.png")
validationplot(rpy_pls_fit, val.type = "MSEP")
dev.off()

# 3) Prediction and MSE
rpy_pls_pred = as.matrix(predict(rpy_pls_fit, rpy_xtest, ncomp = rpy_opt_comp))
rpy_pls_test_mse = mean((rpy_pls_pred - rpy_ytest)^2)

# 4) Fit PLSR on full data set
rpy_pls_full_fit = plsr(rpy_yfull ~ rpy_xfull, scale = TRUE, ncomp = rpy_opt_comp)
summary(rpy_pls_full_fit)
rpy_pls_coef = as.matrix(rpy_pls_full_fit$coefficients[,,rpy_opt_comp])


## PLSR for CDR3
# 1) PLSR Fit
cdr_pls_fit = plsr(cdr_ytrain ~ cdr_xtrain, scale = TRUE, validation = "CV")
cdr_opt_comp <- which.min(cdr_pls_fit$validation$PRESS)
print(paste0("By CV, we can conclude that ", cdr_opt_comp, " components should be used."))

# 2) Plot PLSR
png(file = "../../images/cdr3_plsr_validation.png")
validationplot(cdr_pls_fit, val.type = "MSEP")
dev.off()

# 3) Prediction and MSE
cdr_pls_pred = as.matrix(predict(cdr_pls_fit, cdr_xtest, ncomp = cdr_opt_comp))
cdr_pls_test_mse = mean((cdr_pls_pred - cdr_ytest)^2)

# 4) Fit PLSR on full data set
cdr_pls_full_fit = plsr(cdr_yfull ~ cdr_xfull, scale = TRUE, ncomp = cdr_opt_comp)
summary(cdr_pls_full_fit)
cdr_pls_coef = as.matrix(cdr_pls_full_fit$coefficients[,,cdr_opt_comp])

# Save data
save(rpy_pls_fit, rpy_pls_test_mse, rpy_pls_full_fit, rpy_pls_coef, 
     cdr_pls_fit, cdr_pls_test_mse, cdr_pls_full_fit, cdr_pls_coef,
     file = "../../data/RData/plsr.RData" )