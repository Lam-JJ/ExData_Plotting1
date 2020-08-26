##Read data from .txt file
power <- read.table("household_power_consumption.txt",
                    sep=";",header=TRUE)

#Initialise Packages
library(dplyr)
library(lubridate)
library(ggplot2)

##Convert time and date to respective class
power$datetime <- with(power,paste(Date,Time))
power <- power %>% subset(select = -c(Date,Time)) %>% relocate(datetime)   
power$datetime <- dmy_hms(power$datetime)

# ##Select data from 2007-02-01 to 2007-02-02
power <- filter(power,power$datetime >= as.Date("2007-02-01") 
                & power$datetime < as.Date("2007-02-03"))

##Convert character to numeric
power[,-1] <- lapply(power[,-1],as.numeric)

##Plot 1 Histogram of Global Active Power
png(file="plot1.png",width=480,height=480)
hist(power$Global_active_power,col="red",
     xlab="Global Active Power (kilowatts)",
     main="Global Active Power")
dev.off()