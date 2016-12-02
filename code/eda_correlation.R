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
cm <- colnames(cormat)

# selecting correlation subsets by different response variables
response_vars <- c('RPY_3YR_RT', 'RPY_5YR_RT', 'RPY_7YR_RT', 'CDR3')
cor_rpy_3yr <- cormat[ , 'RPY_3YR_RT']
cor_rpy_5yr <- cormat[ , 'RPY_5YR_RT']
cor_rpy_7yr <- cormat[ , 'RPY_7YR_RT']
cor_cdr3 <- cormat[ , 'CDR3']

rpy_vars <- grep('rpy', cm[!cm %in% response_vars], ignore.case = TRUE)

# removes all repayment related columns
cor_rpy_3yr <- cor_rpy_3yr[names(cor_rpy_3yr)[-rpy_vars]]
cor_rpy_5yr <- cor_rpy_5yr[names(cor_rpy_5yr)[-rpy_vars]]
cor_rpy_7yr <- cor_rpy_7yr[names(cor_rpy_7yr)[-rpy_vars]]
cor_cdr3 <- cor_cdr3[names(cor_cdr3)[-rpy_vars]]

# variables with above .5 correlation with specified response (in descending order)
high_cor_rpy_3yr <- sort(cor_rpy_3yr[abs(cor_rpy_3yr) > .5],decreasing = T)
high_cor_rpy_5yr <- sort(cor_rpy_5yr[abs(cor_rpy_5yr) > .5],decreasing = T)
high_cor_rpy_7yr <- sort(cor_rpy_7yr[abs(cor_rpy_7yr) > .5],decreasing = T)
high_cor_cdr3 <- sort(cor_cdr3[abs(cor_cdr3) > .5],decreasing = T)

hi_lst <- list(high_cor_rpy_3yr, high_cor_rpy_5yr, high_cor_rpy_7yr, high_cor_cdr3)
hi_lst <- lapply(hi_lst, names)
for (i in 1:(length(vars))) {
  hi_lst[[i]] <- append(hi_lst[[i]], vars[i])
}

vt <- list()
for (i in length(hi_lst)) {
  vt[[i]] <- clean_data[,hi_lst[[i]]]
  vt[[i]] <- lm(colnames(vt[i])[ncol(vt[i])] ~ ., data = vt[i], na.action = na.exclude)
}

# 3/5/7 Yr Repayment Rates & CDR3 tables

variables_tbl <- clean_data[,names(high_cor_rpy_3yr)]
variables_tbl$RPY_3YR_RT <- clean_data$RPY_3YR_RT

reg <- lm(RPY_3YR_RT ~ ., data = variables_tbl, na.action = na.exclude)
a <- summary(reg)
a$coefficients[,'Pr(>|t|)']

str(variables_tbl)

head(clean_data$PAR_ED_PCT_1STGEN)
summary(clean_data$FIRST_GEN)
sum(is.na(clean_data$MD_EARN_WNE_P6))
length(clean_data$MD_EARN_WNE_P6)
cor(clean_data$RPY_3YR_RT, clean_data$CDR3, use = "pairwise.complete.obs")
plot(clean_data$DEBT_MDN, clean_data$RPY_3YR_RT)
