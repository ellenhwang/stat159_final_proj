library(corrplot)

clean_data = read.csv("../data/cleaned_data/clean_data.csv")
names = clean_data[,3]

remove_null_and_privsup <- function(col) {
  col[col == "NULL"] = NA
  col[col == "PrivacySuppressed"] = NA
  col
}

clean_data <- as.data.frame(apply(clean_data, 2, remove_null_and_privsup))
clean_data <- as.data.frame(sapply(clean_data, function(f) {as.numeric(levels(f))[f]}))
clean_data <- clean_data[,-3] # Drop Names

cormat <- cor(clean_data, use="pairwise.complete.obs")

repayment_3year_corrs <- cormat[, 'RPY_3YR_RT']
repayment_5year_corrs <- cormat[, 'RPY_5YR_RT']
repayment_7year_corrs <- cormat[, 'RPY_7YR_RT']

repayment_3year_predictors <- repayment_3year_corrs[abs(repayment_3year_corrs) > 0.5]
repayment_5year_predictors <- repayment_5year_corrs[abs(repayment_5year_corrs) > 0.5]
repayment_7year_predictors <- repayment_7year_corrs[abs(repayment_7year_corrs) > 0.5]

rep_names = grep('RPY', names(repayment_3year_predictors))
repayment_3year_predictors <- repayment_3year_predictors[-rep_names]
repayment_5year_predictors <- repayment_5year_predictors[-rep_names]
repayment_7year_predictors <- repayment_7year_predictors[-rep_names]