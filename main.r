train <- read.csv("train_data.txt")
library(lubridate)
set.seed(1)

### Training Data Preprocessing

# Make sure that Date column is actually a Date object
train$Date <- as.Date(train$Date, "%d/%m/%Y")

# Add day of week attribute
train$Day_of_week <- weekdays(as.Date(train$Date, "%d/%m/%Y"))

# Remove rows that have any null attributes
train <- train[rowSums(is.na(train)) == 0,]

# Create specific date intervals
christmas <- train[month(train$Date) == 12 & day(train$Date) == 25,]
thanksgiving <- subset(train, train$Date %in% date(c("2007-11-22", "2008-11-27", "2009-11-26")))
black_friday <- subset(train, train$Date %in% date(c("2007-11-23", "2008-11-28", "2009-11-27")))

weekends <- train[train$Day_of_week %in% c("Saturday", "Sunday"),]
weekdays <- train[train$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]

winter <- subset(train, month(train$Date) %in% c(12, 1, 2))
spring <- subset(train, month(train$Date) %in% c(3, 4, 5))
summer <- subset(train, month(train$Date) %in% c(6, 7, 8))
fall <- subset(train, month(train$Date) %in% c(9, 10, 11))

# Create time windows
weekdays.evenings <- weekdays[hour(hms(weekdays$Time)) >= 18 & hour(hms(weekdays$Time)) < 24,]
weekdays.nights <- weekdays[hour(hms(weekdays$Time)) >= 0 & hour(hms(weekdays$Time)) < 6, ]
weekdays.mornings <- weekdays[hour(hms(weekdays$Time)) >= 6 & hour(hms(weekdays$Time)) < 12,]
weekdays.afternoons <- weekdays[hour(hms(weekdays$Time)) >= 12 & hour(hms(weekdays$Time)) < 18,]

weekends.evenings <- weekends[hour(hms(weekends$Time)) >= 18 & hour(hms(weekends$Time)) < 24,]
weekends.nights <- weekends[hour(hms(weekends$Time)) >= 0 & hour(hms(weekends$Time)) < 6, ]
weekends.mornings <- weekends[hour(hms(weekdays$Time)) >= 6 & hour(hms(weekends$Time)) < 12,]
weekends.afternoons <- weekends[hour(hms(weekends$Time)) >= 12 & hour(hms(weekends$Time)) < 18,]

summer.evenings <- summer[hour(hms(summer$Time)) >= 18 & hour(hms(summer$Time)) < 24,]
summer.nights <- summer[hour(hms(summer$Time)) >= 0 & hour(hms(summer$Time)) < 6,]
summer.mornings <- summer[hour(hms(summer$Time)) >= 6 & hour(hms(summer$Time)) < 12,]
summer.afternoons <- summer[hour(hms(summer$Time)) >= 12 & hour(hms(summer$Time)) < 18,]

fall.evenings <- fall[hour(hms(fall$Time)) >= 18 & hour(hms(fall$Time)) < 24,]
fall.nights <- fall[hour(hms(fall$Time)) >= 0 & hour(hms(fall$Time)) < 6,]
fall.mornings <- fall[hour(hms(fall$Time)) >= 6 & hour(hms(fall$Time)) < 12,]
fall.afternoons <- fall[hour(hms(fall$Time)) >= 12 & hour(hms(fall$Time)) < 18,]

winter.evenings <- winter[hour(hms(winter$Time)) >= 18 & hour(hms(winter$Time)) < 24,]
winter.nights <- winter[hour(hms(winter$Time)) >= 0 & hour(hms(winter$Time)) < 6,]
winter.mornings <- winter[hour(hms(winter$Time)) >= 6 & hour(hms(winter$Time)) < 12,]
winter.afternoons <- winter[hour(hms(winter$Time)) >= 12 & hour(hms(winter$Time)) < 18,]

spring.evenings <- spring[hour(hms(spring$Time)) >= 18 & hour(hms(spring$Time)) < 24,]
spring.nights <- spring[hour(hms(spring$Time)) >= 0 & hour(hms(spring$Time)) < 6,]
spring.mornings <- spring[hour(hms(spring$Time)) >= 6 & hour(hms(spring$Time)) < 12,]
spring.afternoons <- spring[hour(hms(spring$Time)) >= 12 & hour(hms(spring$Time)) < 18,]

christmas.evenings <- christmas[hour(hms(christmas$Time)) >= 18 & hour(hms(christmas$Time)) < 24,]
christmas.nights <- christmas[hour(hms(christmas$Time)) >= 0 & hour(hms(christmas$Time)) < 6,]
christmas.mornings <- christmas[hour(hms(christmas$Time)) >= 6 & hour(hms(christmas$Time)) < 12,]
christmas.afternoons <- christmas[hour(hms(christmas$Time)) >= 12 & hour(hms(christmas$Time)) < 18,]






