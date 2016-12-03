# ################################################################
# EDA
# ################################################################
# import data
clean_data <- read.csv('../data/cleaned_data/clean_data.csv')

# libraries
library(ggplot2)
library(gridExtra)

# ***************************************************************************
# Barplots
# ***************************************************************************
# Quick Barplot Aggregated Mean Function
agg_grp <- function(columns, fun) {
  a <- clean_data[, columns]
  a <- na.omit(a)
  b <- aggregate(a[, columns[1]], by = list(as.factor(a[,columns[2]])), fun) # Region 0 not included bc 1 obs
  ggplot(b, aes(x = factor(Group.1), y = x)) + geom_bar(stat = "identity")+geom_text(aes(label = round(x,2)), vjust = 3, size = 5) +
    ggtitle(paste("Barplot of Mean", columns[1], "on", columns[2], "Levels")) + xlab(columns[2]) + ylab(columns[1])
}

# Average 3 yr Repayment Rate by Region
rpy_region_barplot <- agg_grp(c('RPY_3YR_RT', 'REGION'), mean)
rpy_control_barplot <- agg_grp(c('RPY_3YR_RT', 'CONTROL'), mean)
rpy_iclevel_barplot <- agg_grp(c('RPY_3YR_RT', 'ICLEVEL'), mean)

# ***************************************************************************
# Histograms
# ***************************************************************************
# Repayment Rate Distributions for different types of schools
public_hist <- ggplot(clean_data[clean_data$CONTROL == 1, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle('Distribution of 3 Yr Repayment Rates for Public Schools')
private_np_hist <- ggplot(clean_data[clean_data$CONTROL == 2, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle('Distribution of 3 Yr Repayment Rates for Private-NonProfit Schools')
private_fp_hist <- ggplot(clean_data[clean_data$CONTROL == 3, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle('Distribution of 3 Yr Repayment Rates for Private-ForProfit Schools')

fouryr_hist <- ggplot(clean_data[clean_data$ICLEVEL == 1, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle('Distribution of 3 Yr Repayment Rates for 4 Year Institutions')
twoyr_hist <- ggplot(clean_data[clean_data$ICLEVEL == 2, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle('Distribution of 3 Yr Repayment Rates for 2 Year Institutions')
less2yr_hist <- ggplot(clean_data[clean_data$ICLEVEL == 3, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle('Distribution of 3 Yr Repayment Rates for Less Than 2 Year Institutions')

# ***************************************************************************
# Scatter Plots
# ***************************************************************************
# Tuition vs 3 Yr Repayment Rate
tuition_plot <- ggplot(clean_data, aes(x = log10(TUITFTE), y = RPY_3YR_RT)) + geom_point() + ggtitle('Scatter Plot of Log(Tuition) on 3 Yr Repayment Rate')
tuitionin_plot <- ggplot(clean_data, aes(x = log10(TUITIONFEE_IN), y = RPY_3YR_RT)) + geom_point() + ggtitle('Scatter Plot of Log(Tuition In State) on 3 Yr Repayment Rate')
tuitionout_plot <- ggplot(clean_data, aes(x = log10(TUITIONFEE_OUT), y = RPY_3YR_RT)) + geom_point() + ggtitle('Scatter Plot of Log(Tuition Out of State) on 3 Yr Repayment Rate')

# Completion Rate vs 3 Yr Repayment Rate
complrt_rpy3yr_scatter <- ggplot(clean_data, aes(x = C100_4, y = RPY_3YR_RT)) + geom_point() + geom_smooth() +
  ggtitle('Scatter Plot of 3 Yr Repayment Rate vs \n Completion Rate for First-Time, Full-Time Students at 4 Yr Institutions') +
    labs(y = '3 Yr Repayment Rate', x = 'Completion Rate for First-Time, Full-Time Students at 4 Yr Institutions')

# Average Net Price for Public Institutions vs Repayment Rate
netprice_pub_rpy3yr_scatter <- ggplot(clean_data, aes(x = NPT4_PUB, y = RPY_3YR_RT)) + geom_point() + geom_smooth(method='lm') +
  ggtitle('Scatter Plot of 3 Yr Repayment Rate vs \n Average Net Price for Public Institutions') +
  labs(y = '3 Yr Repayment Rate', x = 'Average Net Price for Public Institutions')

netprice_priv_rpy3yr_scatter <- ggplot(clean_data, aes(x = NPT4_PRIV, y = RPY_3YR_RT)) + geom_point() + geom_smooth(method='lm') +
  ggtitle('Scatter Plot of 3 Yr Repayment Rate vs \n Average Net Price for Private Institutions') +
  labs(y = '3 Yr Repayment Rate', x = 'Average Net Price for Private Institutions')

pctfloan_rpy3yr_scatter <- ggplot(clean_data, aes(x = PCTFLOAN, y = RPY_3YR_RT)) + geom_point() + geom_smooth(method='lm') +
  ggtitle('Scatter Plot of 3 Yr Repayment Rate vs \n Percent of Students Who Received Federal Student Loans') +
  labs(y = '3 Yr Repayment Rate', x = 'Percent of Students Who Received Federal Student Loans')

# ***************************************************************************
# Export Plots
# ***************************************************************************
png('../images/eda/rpy_region_barplot.png')
rpy_region_barplot
dev.off()

png('../images/eda/rpy3yr_control_barplot_histogram.png', width = 909, height = 488)
grid.arrange(rpy_control_barplot, grid.arrange(public_hist, private_np_hist, private_fp_hist), ncol = 2)
dev.off()

png('../images/eda/iclevel_rpy3yr_histogram.png', width = 909, height = 488)
grid.arrange(rpy_iclevel_barplot, grid.arrange(fouryr_hist, twoyr_hist, less2yr_hist), ncol = 2)
dev.off()

png('../images/eda/rpy3yr_tuition_scatter.png')
grid.arrange(tuition_plot, tuitionin_plot, tuitionout_plot)
dev.off()

png('../images/eda/complrt_rpy3yr_scatter.png')
complrt_rpy3yr_scatter
dev.off()

png('../images/eda/netprice_pub_priv_rpy3yr_scatter.png')
grid.arrange(netprice_pub_rpy3yr_scatter, netprice_priv_rpy3yr_scatter)
dev.off()

png('../images/eda/pctfloan_rpy3yr_scatter.png')
pctfloan_rpy3yr_scatter
dev.off()
