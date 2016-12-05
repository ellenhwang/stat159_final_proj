library(ggplot2)
library(gridExtra)

clean_data <- read.csv('./data/clean_data.csv')

# Quick Barplot Aggregated Mean Function
agg_grp <- function(columns, fun) {
  a <- clean_data[, columns]
  a <- na.omit(a)
  b <- aggregate(a[, columns[1]], by = list(as.factor(a[,columns[2]])), fun) # Region 0 not included bc 1 obs
  ggplot(b, aes(x = factor(Group.1), y = x)) + geom_bar(stat = "identity")+geom_text(aes(label = round(x,2)), vjust = 3, size = 5) +
    ggtitle(paste("Barplot of Mean", columns[1], "on", columns[2], "Levels")) + xlab(columns[2]) + ylab(columns[1])
}

clean_data$l10tuit <- log10(clean_data$TUITFTE)
clean_data$degtype <- sapply(5 - clean_data$HIGHDEG, FUN=function(x){min(3, x)})
clean_data$region <- sapply(clean_data$REGION / 2, FUN=ceiling)

ColToNameMap <- c("log10(Tuition)", "Completion Rate", "Average Net Price")
names(ColToNameMap) <- c("l10tuit", "C100_4", "NPT4_PUB")

SplitToNamesMap <- c('3 Yr Rates for Public Schools', 'For Private-NonProfit Schools', 'For Private-ForProfit Schools',
                     '3 Yr Rates for Four-Year Degrees', 'For Two-Year Degrees', 'For Less-Than-Two-Year Degrees',
                     'Schools granting graduate degrees', 'Granting only 4-year degrees', 'Granting only 2-year degrees',
                     "Schools in the Northeast", "In the Midwest", "In the South", "In the West")
names(SplitToNamesMap) <- c("CONTROL 1", "CONTROL 2", "CONTROL 3",
                            "ICLEVEL 1", "ICLEVEL 2", "ICLEVEL 3",
                            "degtype 1", "degtype 2", "degtype 3",
                            "region 1", "region 2", "region 3", "region 4")