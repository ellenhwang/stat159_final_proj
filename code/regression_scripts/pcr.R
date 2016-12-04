#####################################################
###### Principal Component Regression Analysis ######
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

## PCR for RPY3YR
set.seed(1234)
# 1) PCR fit
rpy_pcr_fit= pcr(rpy_ytrain ~ rpy_xtrain, scale = TRUE, validation = "CV")

# 2) List of validation error for PCR
rpy_pcr_min_validation <- rpy_pcr_fit$validation$PRESS
rpy_opt_comp <- which.min(rpy_pcr_fit$validation$PRESS)
print(paste0("Lowest CV error is with ", rpy_opt_comp, " components."))

# 3) PCR validation plot
png("../../images/rpy3yr_pcr_validation.png")
validationplot(rpy_pcr_fit, val.type = "MSEP")
dev.off()

# 4) Prediction and MSE
rpy_pcr_pred = as.matrix(predict(rpy_pcr_fit, rpy_xtest, ncomp = rpy_opt_comp))
rpy_pcr_test_mse <- mean((rpy_pcr_pred - rpy_ytest)^2)

# 5) Fit PCR on full data set
rpy_pcr_full_fit= pcr(rpy_yfull ~ rpy_xfull, scale = TRUE, ncomp = rpy_opt_comp)
rpy_pcr_coef <- as.matrix(rpy_pcr_full_fit$coefficients[,,rpy_opt_comp])


## PCR for CDR3
# 1) PCR fit
cdr_pcr_fit= pcr(cdr_ytrain ~ cdr_xtrain, scale = TRUE, validation = "CV")

# 2) List of validation error for PCR
cdr_pcr_min_validation <- cdr_pcr_fit$validation$PRESS
cdr_opt_comp <- which.min(cdr_pcr_fit$validation$PRESS)
print(paste0("Lowest CV error is with ", cdr_opt_comp, " components"))

# 3) PCR validation plot
png("../../images/cdr3_pcr_validation.png")
validationplot(cdr_pcr_fit, val.type = "MSEP")
dev.off()

# 4) Prediction and MSE
cdr_pcr_pred = as.matrix(predict(cdr_pcr_fit, cdr_xtest, ncomp = cdr_opt_comp))
cdr_pcr_test_mse <- mean((cdr_pcr_pred - cdr_ytest)^2)

# 5) Fit PCR on full data set
cdr_pcr_full_fit= pcr(cdr_yfull ~ cdr_xfull, scale = TRUE, ncomp = cdr_opt_comp)
cdr_pcr_coef <- as.matrix(cdr_pcr_full_fit$coefficients[,,cdr_opt_comp])

save(rpy_pcr_fit, rpy_pcr_min_validation, rpy_pcr_test_mse, rpy_pcr_full_fit, rpy_pcr_coef,
     cdr_pcr_fit, cdr_pcr_min_validation, cdr_pcr_test_mse, cdr_pcr_full_fit, cdr_pcr_coef,
     file = "../../data/RData/pcr.RData")
