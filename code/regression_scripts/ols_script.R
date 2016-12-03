# ################################################################
# OLS Regression
# ################################################################
rpy_3yr_tbl <- read.csv('../../data/cleaned_data/rpy3yr_tbl.csv')
cdr3_tbl <- read.csv('../../data/cleaned_data/cdr3_tbl.csv')

rpy_3yr_reg <- lm(RPY_3YR_RT ~ ., data = rpy_3yr_tbl)
rpy_3yr_regsum <- summary(rpy_3yr_reg)

cdr3_reg <- lm(CDR3 ~ ., data = cdr3_tbl)
cdr3_regsum <- summary(cdr3_reg)

save(rpy_3yr_reg, rpy_3yr_regsum, cdr3_reg, cdr3_regsum, file = '../../data/RData/ols.RData')