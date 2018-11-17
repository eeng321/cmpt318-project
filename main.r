train <- read.csv("train_data.txt")
library(lubridate)
library(depmixS4)
library(ggplot2)
library(zoo)

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
halloween <- train[month(train$Date) == 10 & day(train$Date) == 31,]

winter <- subset(train, month(train$Date) %in% c(12, 1, 2))
spring <- subset(train, month(train$Date) %in% c(3, 4, 5))
summer <- subset(train, month(train$Date) %in% c(6, 7, 8))
fall <- subset(train, month(train$Date) %in% c(9, 10, 11))

# Create time windows
summer.weekdays <- subset(summer, summer$Day_of_week %in% c("Monday, Tuesday", "Wednesday", "Thursday", "Friday"))
summer.weekends <- subset(summer, summer$Day_of_week %in% c("Saturday", "Sunday"))



summer.weekdays.evenings <- summer.weekdays[hour(hms(summer.weekdays$Time)) >= 18 & hour(hms(summer.weekdays$Time)) < 24,]
summer.weekdays.nights <- summer.weekdays[hour(hms(summer.weekdays$Time)) >= 0 & hour(hms(summer.weekdays$Time)) < 6,]
summer.weekdays.mornings <- summer.weekdays[hour(hms(summer$Time)) >= 6 & hour(hms(summer$Time)) < 12,]
summer.weekdays.afternoons <- summer.weekdays[hour(hms(summer.weekdays$Time)) >= 12 & hour(hms(summer.weekdays$Time)) < 18,]

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


# Intersection of time windows
summer.weekday.evenings <- summer.evenings[summer.evenings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
summer.weekday.nights <- summer.nights[summer.nights$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
summer.weekday.mornings <- summer.mornings[summer.mornings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
summer.weekday.afternoons <- summer.mornings[summer.mornings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]

summer.weekend.evenings <- summer.evenings[summer.evenings$Day_of_week %in% c("Saturday", "Sunday"),]
summer.weekend.nights <- summer.nights[summer.evenings$Day_of_week %in% c("Saturday", "Sunday"),]
summer.weekend.mornings <- summer.mornings[summer.evenings$Day_of_week %in% c("Saturday", "Sunday"),]
summer.weekend.afternoons <- summer.afternoons[summer.evenings$Day_of_week %in% c("Saturday", "Sunday"),]

fall.weekday.evenings <- fall.evenings[fall.evenings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
fall.weekday.nights <- fall.nights[fall.nights$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
fall.weekday.mornings <- fall.mornings[fall.mornings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
fall.weekday.afternoons <- fall.afternoons[fall.afternoons$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]

fall.weekend.evenings <- fall.evenings[fall.evenings$Day_of_week %in% c("Saturday", "Sunday"),]
fall.weekend.nights <- fall.nights[fall.nights$Day_of_week %in% c("Saturday", "Sunday"),]
fall.weekend.mornings <- fall.mornings[fall.mornings$Day_of_week %in% c("Saturday", "Sunday"),]
fall.weekend.afternoons <- fall.afternoons[fall.afternoons$Day_of_week %in% c("Saturday", "Sunday"),]

winter.weekday.evenings <- winter.evenings[winter.evenings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),] 
winter.weekday.nights <- winter.nights[winter.nights$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
winter.weekday.mornings <- winter.mornings[winter.mornings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
winter.weekday.afternoons <- winter.afternoons[winter.afternoons$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]

winter.weekend.evenings <- winter.evenings[winter.evenings$Day_of_week %in% c("Saturday", "Sunday"),]
winter.weekend.nights <- winter.nights[winter.nights$Day_of_week %in% c("Saturday", "Sunday"),]
winter.weekend.mornings <- winter.mornings[winter.mornings$Day_of_week %in% c("Saturday", "Sunday"),]
winter.weekend.afternoons <- winter.afternoons[winter.afternoons$Day_of_week %in% c("Saturday", "Sunday"),]

spring.weekday.evenings <- spring.evenings[spring.evenings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
spring.weekday.nights <- spring.nights[spring.nights$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
spring.weekday.mornings <- spring.mornings[spring.mornings$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]
spring.weekday.afternoons <- spring.afternoons[spring.afternoons$Day_of_week %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday"),]

spring.weekend.evenings <- spring.evenings[spring.evenings$Day_of_week %in% c("Saturday", "Sunday"),]
spring.weekend.nights <- spring.nights[spring.nights$Day_of_week %in% c("Saturday", "Sunday"),]
spring.weekend.mornings <- spring.mornings[spring.mornings$Day_of_week %in% c("Saturday", "Sunday"),]
spring.weekend.afternoons <- spring.afternoons[spring.afternoons$Day_of_week %in% c("Saturday", "Sunday"),]
