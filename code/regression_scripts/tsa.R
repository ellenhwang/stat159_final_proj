### Time Series Analysis on 3 year Repayment Rate ###
# Library
pkg = c("TSA", "forecast", "astsa")
new.pkg = pkg[!(pkg %in% installed.packages()[,"Package"])]
if (length(new.pkg)) {install.packages(new.pkg, dependencies = TRUE)}
sapply(pkg, require, character.only = TRUE)
# Loading data
load('../../data/RData/ts_to_use.RData')
colnames(rpy_allyr) <- c(2009:2014)

# Prediction
rpy_pred <- t(data.frame(rep(NA,3)))
colnames(rpy_pred) <- c(2015, 2016, 2017)
print("Forcasting begins!")
time <- proc.time()
for (i in 1:nrow(rpy_allyr)) {
  if (i > 3) {
    print(paste0(i, "th prediction. ", (nrow(rpy_allyr) - i), " more to go!"))
  } else if (i == 3) {
    print(paste0(i, "rd prediction. ", (nrow(rpy_allyr) - i), " more to go!"))
  } else if (i == 2) {
    print(paste0(i, "nd prediction. ", (nrow(rpy_allyr) - i), " more to go!"))
  } else {
    print(paste0(i, "st prediction. ", (nrow(rpy_allyr) - i), " more to go!"))
  }
  school = as.numeric(rpy_allyr[i,])
  ts = auto.arima(school)
  coef = diag(ts$model$T)
  if (length(coef) != 3) {
    if (coef == 0) {
      if((rpy_allyr[i,3] < rpy_allyr[i,4]) & (rpy_allyr[i,4] < rpy_allyr[i,5]) & (rpy_allyr[i,5] < rpy_allyr[i,6])) {
        coef <- c(0,1,2)
      } else {
        coef <- append(coef, rep(0, (3 - length(coef))))
      }
    } else {
      coef <- append(coef, rep(0, (3 - length(coef))))
    }
  }
  pred <- sarima.for(school, n.ahead = 3, coef[1], coef[2], coef[3])
  print(paste0("Prediction for ", names[i,1], ". ",
               colnames(rpy_pred)[1], ": ", pred$pred[1], ", ",
               colnames(rpy_pred)[2], ": ", pred$pred[2], ", ",
               colnames(rpy_pred)[3], ": ", pred$pred[3]))
  if (i == 1) {
    rpy_pred <- rbind(rpy_pred, c(pred$pred[1], pred$pred[2], pred$pred[3]))
    rpy_pred <- rpy_pred[-1, ]
  } else {
    rpy_pred <- rbind(rpy_pred, c(pred$pred[1], pred$pred[2], pred$pred[3])) 
  }
}
print("Prediction finished.")
print(proc.time() - time)
rownames(rpy_pred) <- rownames(rpy_allyr)
rpy_upto_2017 <- cbind(rpy_allyr, rpy_pred)

# Save the Result
print("Saving prediction data...")
save(rpy_upto_2017, file = "../../data/RData/tsa_data.RData")

####################################################
##################### ANALYSIS #####################
####################################################

## Schools with more than 90% repayment rate on average in forecast
more_than_90 <- pred[which(apply(pred,1,mean) >= .947),]


