# ################################################################
# OLS Regression
# ################################################################
# load tables
load("../../data/cleaned_predictor_tables.RData")

rpy_3yr_reg <- lm(RPY_3YR_RT ~ ., data = rpy_3yr_tbl)
rpy_3yr_regsum <- summary(rpy_3yr_reg)

cdr3_reg <- lm(CDR3 ~ ., data = cdr3_tbl)
cdr3_regsum <- summary(cdr3_reg)

save(rpy_3yr_reg, rpy_3yr_regsum, cdr3_reg, cdr3_regsum, file = '../../data/ols-regression.RData')