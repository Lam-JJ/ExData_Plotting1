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

# Find position of breaks
pos <- ymd_hms(c("2007-02-01 00:00:00","2007-02-02 00:00:00","2007-02-02 23:59:00"))

##Plot 2 Global Active Power Usage over two day
png(file="plot2.png",width=480,height=480)

plot <- ggplot(aes(x = datetime,y= Global_active_power),data = power) 
plot + geom_line() + 
    labs(y="Global Active Power (kilowatt)", x= "") +
    scale_x_continuous(breaks=pos,label = c("Thu","Fri","Sat")) +
    theme_classic() +
    theme(axis.text.x = element_text(face="bold"),axis.text.y = element_text((face="bold")))

dev.off()