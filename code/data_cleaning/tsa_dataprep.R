# ***************************************************************************************
# Clean NULL and PrivacySuppressed and converting values to numeric
# ***************************************************************************************
source('../functions/functions.R')
clean_data_all <- function(clean_data) {
  names = clean_data[,"INSTNM"]
  clean_data$INSTNM <- NULL
  clean_data <- as.data.frame(apply(clean_data, 2, remove_null_and_privsup))
  clean_data <- as.data.frame(sapply(clean_data, function(f) {as.numeric(levels(f))[f]}))
  clean_data$INSTNM <- names
  return(clean_data)
}

# Import data
keep_cr = c("UNITID", "INSTNM", "RPY_3YR_RT")
m1 = clean_data_all(read.csv("../../data/raw_data/MERGED2009_10_PP.csv", stringsAsFactors = FALSE)[,keep_cr])
m2 = clean_data_all(read.csv("../../data/raw_data/MERGED2010_11_PP.csv", stringsAsFactors = FALSE)[,keep_cr])
m3 = clean_data_all(read.csv("../../data/raw_data/MERGED2011_12_PP.csv", stringsAsFactors = FALSE)[,keep_cr])
m4 = clean_data_all(read.csv("../../data/raw_data/MERGED2012_13_PP.csv", stringsAsFactors = FALSE)[,keep_cr])
m5 = clean_data_all(read.csv("../../data/raw_data/MERGED2013_14_PP.csv", stringsAsFactors = FALSE)[,keep_cr])
m6 = clean_data_all(read.csv("../../data/raw_data/MERGED2014_15_PP.csv", stringsAsFactors = FALSE)[,keep_cr])

# Merge to get the schools that all appear on all the data sets
merge12 = merge(x = m1, y = m2, by = "UNITID", all = FALSE)
merge123 = merge(x = merge12, y = m3, by = "UNITID", all = FALSE)
merge1234 = merge(x = merge123, y = m4, by = "UNITID", all = FALSE)
merge12345 = merge(x = merge1234, y = m5, by = "UNITID", all = FALSE)
merge123456 = merge(x = merge12345, y = m6, by = "UNITID", all = FALSE)

# Keep the ID of the schools
keep = merge123456$UNITID

# Clean out the schools that don't appear in all data sets
m1 <- m1[which(m1$UNITID %in% keep),]
m2 <- m2[which(m2$UNITID %in% keep),]
m3 <- m3[which(m3$UNITID %in% keep),]
m4 <- m4[which(m4$UNITID %in% keep),]
m5 <- m5[which(m5$UNITID %in% keep),]
m6 <- m6[which(m6$UNITID %in% keep),]

rpy_allyr <- data.frame(m1$INSTNM, m1$UNITID, m1$RPY_3YR_RT, m2$RPY_3YR_RT, m3$RPY_3YR_RT,
                        m4$RPY_3YR_RT, m5$RPY_3YR_RT, m6$RPY_3YR_RT)
rownames(rpy_allyr) <- rpy_allyr$m1.UNITID

# Get rid of rows with NAs
nas <- complete.cases(rpy_allyr)
rpy_allyr <- rpy_allyr[nas,]
colnames(rpy_allyr[,c(1:2)]) <- c("INSTNM", "UNITID")
colnames(rpy_allyr[,c(3:8)]) <- c(2009:2014)
names <- rpy_allyr[,c(1:2)]
names[,1] <- as.character(names[,1])

# Save cleaned data
write.csv(rpy_allyr, file = "../../data/cleaned_data/ts_data.csv")

rpy_allyr$m1.INSTNM <- NULL
rpy_allyr$m1.UNITID <- NULL
# Save RData
save(rpy_allyr, names, file = "../../data/RData/ts_to_use.RData")
