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

##Plot 3 3 types of Energy sub metering from thu to sat
png(file="plot3.png",width=480,height=480)

plot <- ggplot(aes(x = datetime),data = power) 
plot <- plot + geom_line(aes(y=Sub_metering_1,color="sub_metering_1"))
plot <- plot + geom_line(aes(y=Sub_metering_2,color="sub_metering_2"))
plot <- plot + geom_line(aes(y=Sub_metering_3,color="sub_metering_3"))

plot + labs(y="Energy sub metering", x= "") +
        scale_x_continuous(breaks=pos,label = c("Thu","Fri","Sat")) +
        theme_classic() +
        theme(axis.text.x = element_text(face="bold"),axis.text.y = element_text(face="bold")) +
        theme(legend.position = c(0.78,0.89),legend.title=element_blank()) +
        theme(legend.background = element_rect(colour="black",fill="white",linetype='solid')) +
        scale_colour_manual(values=c("black","red","blue")) 
        
dev.off()

