#################################################################
# EDA: Correlation Matrices for 3/5/7 Yr Repayment Rates & CDR3
#################################################################
# import data
clean_data = read.csv("../data/cleaned_data/clean_data.csv")

# store institution names
names <- clean_data$INSTNM

# remove irrelavant values
clean_data$INSTNM <- NULL
clean_data$LowInc_PostIncomeToCostRatio <- NULL
clean_data$MidInc_PostIncomeToCostRatio <- NULL
clean_data$HighInc_PostIncomeToCostRatio <- NULL

# correlation on all variables
cormat <- cor(clean_data, use = "pairwise.complete.obs")

# selecting correlation subsets by different response variables
response_vars <- c('RPY_3YR_RT', 'RPY_5YR_RT', 'RPY_7YR_RT', 'CDR3')
cor_rpy_3yr <- cormat[ , 'RPY_3YR_RT']
cor_rpy_5yr <- cormat[ , 'RPY_5YR_RT']
cor_rpy_7yr <- cormat[ , 'RPY_7YR_RT']
cor_cdr3 <- cormat[ , 'CDR3']


rpy_vars <- grep('rpy', colnames(cormat), ignore.case = TRUE)

# removes all repayment related columns
cor_rpy_3yr <- cor_rpy_3yr[names(cor_rpy_3yr)[-rpy_vars]]
cor_rpy_5yr <- cor_rpy_5yr[names(cor_rpy_5yr)[-rpy_vars]]
cor_rpy_7yr <- cor_rpy_7yr[names(cor_rpy_7yr)[-rpy_vars]]
cor_cdr3 <- cor_cdr3[names(cor_cdr3)[-rpy_vars]]

# variables with above .5 correlation with specified response (in descending order)
high_cor_rpy_3yr <- sort(cor_rpy_3yr[abs(cor_rpy_3yr) > .5],decreasing = T)
high_cor_rpy_5yr <- sort(cor_rpy_5yr[abs(cor_rpy_5yr) > .5],decreasing = T)
high_cor_rpy_7yr <- sort(cor_rpy_7yr[abs(cor_rpy_7yr) > .5],decreasing = T)
high_cor_cdr3 <- sort(cor_cdr3[abs(cor_cdr3) > .5 & cor_cdr3 != 1],decreasing = T)


# 3/5/7 Yr Repayment Rates & CDR3 tables
rpy_3yr_tbl <- clean_data[,c('RPY_3YR_RT', names(high_cor_rpy_3yr))]
cdr3_tbl <- clean_data[,c('CDR3', names(high_cor_cdr3))]

# Basic OLS regression to see what variables to clean
rpy_3yr_reg <- lm(RPY_3YR_RT ~ ., data = rpy_3yr_tbl)
rpy_3yr_regsum <- summary(rpy_3yr_reg)

cdr3_reg <- lm(CDR3 ~ ., data = cdr3_tbl)
cdr3_regsum <- summary(cdr3_reg)

# Remove variables with greater than .05 pvalue
rpy_3yr_pval <- rpy_3yr_regsum$coefficients[-1,"Pr(>|t|)"]
rpy_3yr_preds <- names(rpy_3yr_pval[rpy_3yr_pval < .05])
rpy_3yr_tbl <- clean_data[,c('RPY_3YR_RT', rpy_3yr_preds)]

cdr3_pval <- cdr3_regsum$coefficients[-1,"Pr(>|t|)"]
cdr3_preds <- names(cdr3_pval[cdr3_pval < .05])
cdr3_tbl <- clean_data[,c('CDR3', cdr3_preds)]

# Save tables 
save(rpy_3yr_tbl, cdr3_tbl, file = "../data/cleaned_predictor_tables.RData")