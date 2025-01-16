install.packages("TTR")
install.packages("pROC")
install.packages("caret")
install.packages("tsModel")
library(TTR)
library(pROC)
library(caret)
library(tsModel)
library(knitr)
aapl= read.csv('AAPL.csv')

str(aapl)
summary(aapl)
kable( head(aapl,1),caption = 'Start Date')
kable( tail(aapl,1),caption = 'End Date')
aapl[mapply(is.infinite, aapl)] <- NA
aapl <- na.omit(aapl)
aapl$Date <- sapply(aapl$Date, function(x) {
  parts <- unlist(strsplit(x, "-")) # 拆分字符串
  paste(parts[3], parts[2], parts[1], sep = "-") # 调整顺序为 年-月-日
})
# 转换为日期格式
aapl$Date <- as.Date(aapl$Date, format = "%Y-%m-%d")
# 筛选10年
aapl <- subset(aapl, Date >= as.Date("2012-01-01") & Date <= as.Date("2022-12-12"))

plot(aapl$Date, aapl$Close, type = "l", col = "blue", 
     xlab = "Date", ylab = "Price", 
     main = "AAPL Price Over Time")

OriReturnFun <- function(vx) {
  return(diff(vx))
}

LogReturnFUn <- function(vx) {
  return(diff(log(vx)))
}

# Calculate log returns
log_returns <- LogReturnFUn(aapl$Close)
aapl$log_returns <- c(NA, log_returns)
OriReturn <- OriReturnFun(aapl$Close)
aapl$returns <- c(NA, OriReturn)
aapl <- na.omit(aapl)
plot(aapl$Date, aapl$returns, type = "l", col = "blue", 
     xlab = "Date", ylab = "Return", 
     main = "Return Over Time")

cat("Mean of Returns:", mean(OriReturn, na.rm = TRUE), "\n")
## Mean of Returns: 0.04634467
cat("Standard Deviation of Returns:", sd(OriReturn, na.rm = TRUE), "\n")
## Standard Deviation of Returns: 1.517186

logreturn_dc <- tsdecomp(aapl$log_returns, c(1, 2, 15, 5114))
x=aapl$Date

par(mfrow = c(3, 1), mar = c(3, 4, 2, 2) + 0.1)
plot(x, logreturn_dc[, 1], type = "l", ylab = "Trend", main = "(a log)")
plot(x, logreturn_dc[, 2], type = "l", ylab = "Seasonal", main = "(b log)")
plot(x, logreturn_dc[, 3], type = "l", ylab = "Residual", main = "(c log)")

# Parametric VaR calculation (70% confidence level)
mean_return <- mean(aapl$returns, na.rm = TRUE)
sd_return <- sd(aapl$returns, na.rm = TRUE)
var_70 <- qnorm(0.20, mean_return, sd_return)
cat("80% Confidence Level VaR:", abs(var_70), "\n")

## 80% Confidence Level VaR: 1.230551
# Define if a default occurred based on  return and VaR
aapl$default <- ifelse(aapl$returns - var_70 < 0, 1, 0)

macd_data <-  data.frame(MACD(aapl$Close))
DIF <- macd_data$macd
DEA <- macd_data$signal
MACD <- 2 * (DIF - DEA)
aapl$macd <- MACD
# Remove NA values
aapl <- na.omit(aapl)

# Split data into training and testing sets
set.seed(123)
train_indices <- sample(1:nrow(aapl), size = floor(0.5 * nrow(aapl)))
train <- aapl[train_indices,-1 ]
test <- aapl[-train_indices, -1]

# Build logistic regression model
logit <- glm(default ~ . , family = binomial(link = "logit"), data = train[,-1])

# Predictions on test set
log_predictions <- predict(logit, newdata = test, type = "response")
log_predictions <- ifelse(log_predictions < 0.5, 0, 1)

# performance 
#  confusion matrix
conf_mat <- confusionMatrix(factor(log_predictions), factor(test$default))
print(conf_mat)

# Plot ROC curve
roc_curve <- roc(test$default, as.numeric(log_predictions))
plot(roc_curve, print.auc = TRUE, auc.polygon = TRUE, grid = c(0.1, 0.2), 
     grid.col = c("green", "red"), max.auc.polygon = TRUE, 
     auc.polygon.col = "skyblue", print.thres = TRUE, main = "Logit Model ROC Curve")
