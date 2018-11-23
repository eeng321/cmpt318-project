## Phase 1 (II) - Linear Regression
library(DAAG)
corMtx <- rbind(
  cor(fw$Global_active_power, fw$Global_intensity),
  cor(fw$Global_active_power, fw$Voltage),
  cor(fw$Global_active_power, fw$Global_reactive_power)
)
rownames(corMtx) <- c("Global intensity", "Voltage", "Global reactive power")
colnames(corMtx) <- c("Global active power")
corMtx # Highest correlation with Global active power is Global intensity

# Use Global intensity to create our linear regression model with Global active power
lm.fw <- lm(Global_active_power ~ Global_intensity, data=fw)
summary(lm.fw)

# Use the linear model lm.fw to predict our test1 dataset values
lmPred.t1.fw <- predict(lm.fw, t1.fw)

# Prediction accuracy measures
actuals_preds <- data.frame(cbind(actuals=t1.fw$Global_active_power, predicted=lmPred.t1.fw))
cor(t1.fw$Global_active_power, lmPred.t1.fw)
# Min-max accuracy - higher the better
print(mean(apply(actuals_preds, 1, min) / apply(actuals_preds, 1, max))) 
# Mean absolute percentage error - lower the better
print(mean(abs((actuals_preds$predicted - actuals_preds$actuals)) / actuals_preds$actuals))
"
ggplot() +
  geom_point(data = fw, aes(Global_intensity, Global_active_power), colour='black', size=1) +
  geom_line(data = actuals_preds, aes(actuals, lmPred.t1.fw), colour='red', size=1) 
"
ggplot(data=t1.fw) +
  geom_point(data = t1.fw, aes(t1.fw$Global_intensity, t1.fw$Global_active_power), colour='red', size=1)
  geom_line(data = actuals_preds, aes(t1.fw$Global_intensity, actuals_preds$predicted), colour='blue', size=1)



plot(x=fw$Global_intensity, y=fw$Global_active_power, pch=16, col='blue')
abline()
  
cvResults <- suppressWarnings(CVlm(fw, form.lm=Global_active_power ~ Global_intensity, m=5, dots=F, seed=1,
                                   legend.pos='topleft', printit=F))
attr(cvResults, 'ms')
