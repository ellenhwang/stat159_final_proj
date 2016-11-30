keep_scorecard = c("UNITID", "INSTNM", "HCM2", "NUMBRANCH", "HIGHDEG", "CONTROL",
                   "REGION", "CCBASIC", "ADM_RATE", "PCIP01", "PCIP03", "PCIP04", "PCIP05",
                   "PCIP09", "PCIP10", "PCIP11", "PCIP12", "PCIP13", "PCIP14", "PCIP15",
                   "PCIP16", "PCIP19", "PCIP22", "PCIP23", "PCIP24", "PCIP25", "PCIP26",
                   "PCIP27", "PCIP29", "PCIP30", "PCIP31", "PCIP38", "PCIP39", "PCIP40",
                   "PCIP41", "PCIP42", "PCIP43", "PCIP44", "PCIP45", "PCIP46", "PCIP47",
                   "PCIP48", "PCIP49", "PCIP50", "PCIP51", "PCIP52", "PCIP54", "UGDS",
                   "UGDS_WHITE", "UGDS_BLACK", "UGDS_HISP", "UGDS_ASIAN", "UGDS_AIAN",
                   "UGDS_NHPI", "UGDS_2MOR", "UGDS_NRA", "UGDS_UNKN", "CURROPER", "NPT4_PUB",
                   "NPT4_PRIV", "NPT41_PUB", "NPT41_PRIV", "NPT4_3075_PUB", "NPT4_3075_PRIV",
                   "NPT4_75UP_PUB", "NPT4_75UP_PRIV", "TUITIONFEE_IN", "TUITIONFEE_OUT",
                   "TUITFTE", "INEXPFTE", "C150_4", "D150_4", "D150_4_POOLED",
                   "C150_4_WHITE", "C150_4_BLACK", "C150_4_HISP", "C150_4_ASIAN", "C150_4_AIAN",
                   "C150_4_NHPI", "C150_4_2MOR", "C150_4_NRA", "C150_4_UNKN", "PCTFLOAN", "CDR3",
                   "rpy3yr_RT", "COMPL_rpy3yr_RT", "NONCOM_rpy3yr_RT", "LO_INC_rpy3yr_RT",
                   "MD_INC_rpy3yr_RT", "HI_INC_rpy3yr_RT", "FIRSTGEN_rpy3yr_RT",
                   "NOTFIRSTGEN_rpy3yr_RT", "RPY_5YR_RT", "COMPL_RPY_5YR_RT",
                   "NONCOM_RPY_5YR_RT", "LO_INC_RPY_5YR_RT", "MD_INC_RPY_5YR_RT",
                   "HI_INC_RPY_5YR_RT", "FIRSTGEN_RPY_5YR_RT", "NOTFIRSTGEN_RPY_5YR_RT",
                   "RPY_7YR_RT", "COMPL_RPY_7YR_RT", "NONCOM_RPY_7YR_RT", "LO_INC_RPY_7YR_RT",
                   "MD_INC_RPY_7YR_RT", "HI_INC_RPY_7YR_RT", "FIRSTGEN_RPY_7YR_RT",
                   "NOTFIRSTGEN_RPY_7YR_RT", "INC_PCT_LO", "PAR_ED_PCT_1STGEN", "INC_PCT_M1",
                   "INC_PCT_M2", "INC_PCT_H1", "INC_PCT_H2",
                   "DEBT_MDN", "GRAD_DEBT_MDN", "WDRAW_DEBT_MDN", "LO_INC_DEBT_MDN",
                   "MD_INC_DEBT_MDN", "HI_INC_DEBT_MDN", "FIRSTGEN_DEBT_MDN",
                   "NOTFIRSTGEN_DEBT_MDN", "LO_INC_DEBT_N", "MD_INC_DEBT_N",
                   "HI_INC_DEBT_N", "LOAN_EVER", "C150_4_POOLED_SUPP",
                   "C200_4_POOLED_SUPP", "C100_4", "ICLEVEL", "CDR3_DENOM")

keep_income = c("UNITID", "MN_EARN_WNE_P6", "MD_EARN_WNE_P6",
                "PCT10_EARN_WNE_P6", "PCT25_EARN_WNE_P6", "PCT75_EARN_WNE_P6",
                "PCT90_EARN_WNE_P6", "SD_EARN_WNE_P6", "GT_25K_P6", "MN_EARN_WNE_INC1_P6",
                "MN_EARN_WNE_INC2_P6", "MN_EARN_WNE_INC3_P6")

scorecard = read.csv("../data/raw_data/MERGED2014_15_PP.csv")
income = read.csv("../data/raw_data/income.csv")

scorecard_subset = scorecard[,keep_scorecard]
income_subset = income[,keep_income]

joined_subset = merge(x = scorecard_subset, y = income_subset, by = "UNITID", all = TRUE)

# ***************************************************************************************
# Feature Engineering STEM and NonSTEM Percentages
# ***************************************************************************************
PCIP_Stem_Values = c(11, 14, 15, 26, 27, 40, 41, 48)

PCIP_Stem_Codes = paste0("PCIP", PCIP_Stem_Values)
PCIP_All_Codes = grep("PCIP", colnames(joined_subset), value = TRUE)
PCIP_All_Codes_Indices = grep("PCIP", colnames(joined_subset))
PCIP_NonStem_Codes = setdiff(PCIP_All_Codes, PCIP_Stem_Codes)

PCIP_Stem_Table = joined_subset[PCIP_Stem_Codes]
PCIP_NonStem_Table = joined_subset[PCIP_NonStem_Codes]

PCIP_Stem_Table = data.frame(sapply(PCIP_Stem_Table, function(c) {as.numeric(levels(c))[c]}))
PCIP_NonStem_Table = data.frame(sapply(PCIP_NonStem_Table, function(c) {as.numeric(levels(c))[c]}))

Stem_Percents = rowSums(PCIP_Stem_Table, na.rm=T)
NonStem_Percents = rowSums(PCIP_NonStem_Table, na.rm=T)

joined_subset$Stem_Percents = Stem_Percents
joined_subset$NonStem_Percents = NonStem_Percents

joined_subset = joined_subset[, -PCIP_All_Codes_Indices] # drop original PCIP columns
# ***************************************************************************************
# Feature Engineering Net Price (NPT) for Each School
# ***************************************************************************************
NPT_Codes_Indices <- grep("NPT", colnames(joined_subset))
Earnings_Codes_Indices <- grep("MN_EARN_WNE",colnames(joined_subset))
joined_subset[,c(NPT_Codes_Indices, Earnings_Codes_Indices)] <- sapply(joined_subset[,c(NPT_Codes_Indices, Earnings_Codes_Indices)], function(c) {as.numeric(levels(c))[c]})
str(joined_subset[,c(NPT_Codes_Indices, Earnings_Codes_Indices)])
joined_subset$NPT_LowInc <- rowSums(joined_subset[,c('NPT41_PUB', 'NPT41_PRIV')], na.rm = T)
joined_subset$NPT_MidInc <- rowSums(joined_subset[, c('NPT4_3075_PUB', 'NPT4_3075_PRIV')], na.rm = T)
joined_subset$NPT_HighInc <- rowSums(joined_subset[, c('NPT4_75UP_PUB', 'NPT4_75UP_PRIV')], na.rm = T)

# filters out schools with no price information
joined_subset <- joined_subset[joined_subset$NPT_HighInc > 0 |
                                 joined_subset$NPT_MidInc > 0 |
                                 joined_subset$NPT_LowInc > 0, ] 

#joined_subset <- joined_subset[, -c(NPT_Codes_Indices)] # drop original PCIP columns

# ***************************************************************************************
# Feature Engineering Value Columns for Each School
# ***************************************************************************************
Earnings_Codes_Indices <- grep("MN_EARN_WNE_INC", colnames(joined_subset), value = TRUE)

joined_subset$LowInc_PostIncomeToCostRatio = joined_subset$MN_EARN_WNE_INC1_P6/joined_subset$NPT_LowInc
joined_subset$MidInc_PostIncomeToCostRatio = joined_subset$MN_EARN_WNE_INC2_P6/joined_subset$NPT_MidInc
joined_subset$HighInc_PostIncomeToCostRatio = joined_subset$MN_EARN_WNE_INC3_P6/joined_subset$NPT_HighInc



# ***************************************************************************************
# Clean NULL and PrivacySuppressed and converting values to numeric
# ***************************************************************************************
source('functions/functions.R')

names = joined_subset[,"INSTNM"]
joined_subset$INSTNM <- NULL

joined_subset <- as.data.frame(apply(joined_subset, 2, remove_null_and_privsup))
joined_subset <- as.data.frame(sapply(joined_subset, function(f) {as.numeric(levels(f))[f]}))

joined_subset$INSTNM <- names


# ***************************************************************************************
# Correlation Matrices for 3/5/7 Yr Repayment Rates & CDR3 to see what predictors to use
# ***************************************************************************************
clean_data <- joined_subset

# remove irrelavant values
clean_data$INSTNM <- NULL
clean_data$LowInc_PostIncomeToCostRatio <- NULL
clean_data$MidInc_PostIncomeToCostRatio <- NULL
clean_data$HighInc_PostIncomeToCostRatio <- NULL

# correlation on all variables
cormat <- cor(clean_data, use = "pairwise.complete.obs")

# selecting correlation subsets by different response variables
response_vars <- c('rpy3yr_RT', 'RPY_5YR_RT', 'RPY_7YR_RT', 'CDR3')
cor_rpy3yr <- cormat[ , 'rpy3yr_RT']
cor_rpy_5yr <- cormat[ , 'RPY_5YR_RT']
cor_rpy_7yr <- cormat[ , 'RPY_7YR_RT']
cor_cdr3 <- cormat[ , 'CDR3']


rpy_vars <- grep('rpy', colnames(cormat), ignore.case = TRUE)

# removes all repayment related columns
cor_rpy3yr <- cor_rpy3yr[names(cor_rpy3yr)[-rpy_vars]]
cor_rpy_5yr <- cor_rpy_5yr[names(cor_rpy_5yr)[-rpy_vars]]
cor_rpy_7yr <- cor_rpy_7yr[names(cor_rpy_7yr)[-rpy_vars]]
cor_cdr3 <- cor_cdr3[names(cor_cdr3)[-rpy_vars]]

# variables with above .5 correlation with specified response (in descending order)
high_cor_rpy3yr <- sort(cor_rpy3yr[abs(cor_rpy3yr) > .5],decreasing = T)
high_cor_rpy_5yr <- sort(cor_rpy_5yr[abs(cor_rpy_5yr) > .5],decreasing = T)
high_cor_rpy_7yr <- sort(cor_rpy_7yr[abs(cor_rpy_7yr) > .5],decreasing = T)
high_cor_cdr3 <- sort(cor_cdr3[abs(cor_cdr3) > .5 & cor_cdr3 != 1],decreasing = T)


# 3/5/7 Yr Repayment Rates & CDR3 tables
rpy3yr_tbl <- clean_data[,c('rpy3yr_RT', names(high_cor_rpy3yr))]
cdr3_tbl <- clean_data[,c('CDR3', names(high_cor_cdr3))]

# Basic OLS regression to see what variables to clean
rpy3yr_reg <- lm(rpy3yr_RT ~ ., data = rpy3yr_tbl)
rpy3yr_regsum <- summary(rpy3yr_reg)

cdr3_reg <- lm(CDR3 ~ ., data = cdr3_tbl)
cdr3_regsum <- summary(cdr3_reg)

# Remove variables with greater than .05 pvalue
rpy3yr_pval <- rpy3yr_regsum$coefficients[-1,"Pr(>|t|)"]
rpy3yr_preds <- names(rpy3yr_pval[rpy3yr_pval < .05])
rpy3yr_tbl <- clean_data[,c('rpy3yr_RT', rpy3yr_preds)]

cdr3_pval <- cdr3_regsum$coefficients[-1,"Pr(>|t|)"]
cdr3_preds <- names(cdr3_pval[cdr3_pval < .05])
cdr3_tbl <- clean_data[,c('CDR3', cdr3_preds)]

# Create Train and Test Sets
set.seed(1)
train_samp <- sample(nrow(clean_data), 0.7*nrow(clean_data))
test_samp <- setdiff(seq_len(nrow(clean_data)), train_samp)

rpy3yr_train <- rpy3yr_tbl[train_samp,]
rpy3yr_test <- rpy3yr_tbl[test_samp,]

cdr3_train <- cdr3_tbl[train_samp,]
cdr3_test <- cdr3_tbl[test_samp,]

write.csv(train, file = 'data/train.csv')
write.csv(test, file = 'data/test.csv')

# ***************************************************************************************
# Export Datasets
# ***************************************************************************************
write.csv(rpy3yr_train, "../data/cleaned_data/rpy3yr_train.csv")
write.csv(rpy3yr_test, "../data/cleaned_data/rpy3yr_test.csv")
write.csv(rpy3yr_tbl, "../data/cleaned_data/rpy3yr_tbl.csv")

write.csv(cdr3_train, "../data/cleaned_data/cdr3_train.csv")
write.csv(cdr3_test, "../data/cleaned_data/cdr3_test.csv")
write.csv(cdr3_tbl, "../data/cleaned_data/cdr3_tbl.csv")

write.csv(joined_subset, file = "../data/cleaned_data/clean_data.csv")

