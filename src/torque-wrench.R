# Filename: torque-wrench.R
# Date: April 6, 2010
# Author: Jason Moore
# Description: Analyzes the data from the bicycle torque wrench experiments
# performed on April 6, 2010.

library(ggplot2)
library(reshape2)

rm(list = ls())

"../figures" -> figDir
"../data" -> dataDir

# read the data
data <- read.csv(file.path(dataDir, 'torque-wrench-data.txt'))

# miles per hour to meters per second
mph2mps <- 0.44704
# inch pounds to newton meters
inchlb2nm <- 0.112984829

data$averageSpeed <- (data$MaxSpeed + data$MinSpeed) / 2
data$MaxTorque <- inchlb2nm * data$MaxTorque

melted <- melt(data, measure.vars=c("MaxTorque", "MinTorque"))

# histogram of the average run speeds
qplot(data=data, x=averageSpeed)
ggsave(file.path(figDir, "twrench-speed-histogram.pdf"), width=4, height=4)

# histogram of the max/min torque values
plot <- ggplot(melted, aes(x=abs(value))) #, binwidth=25)
plot <- plot + xlab("Absolute value of max and min torques [Nm]")
plot <- plot + ggtitle("Histogram of Torque Values")
ggsave(file.path(figDir, "twrench-torque-histogram.pdf"), width=4, height=4)

# torque versus speed for all the runs
plot <- ggplot(melted, aes(x=mph2mps * averageSpeed, value, color=Maneuver))
plot <- plot + geom_point(size=2)
plot <- plot + xlab('Speed [m/s]')
plot <- plot + ylab('Torque [Nm]')
plot <- plot + ggtitle('Max and Min Torques as a \nFunction of Average Speed')
ggsave(file.path(figDir, "twrench-torque-speed.pdf"), width=4, height=4)


maneuvers <- unique(data$Maneuver)
print(maneuvers)
for(maneuver in levels(maneuvers)){
    print(maneuver)
    pdf(file.path(figDir, paste("twrench-", maneuver, ".pdf", sep="")))
    x <- subset(mph2mps * data$averageSpeed, data$Maneuver==maneuver)
    y <- subset(data$MinTorque, data$Maneuver==maneuver)
    y2 <- subset(inchlb2nm*data$MaxTorque, data$Maneuver==maneuver)
    plot(0:10,-5:5, type="n", main=maneuver, xlab="Speed [m/s]", ylab="Torque [Nm]")
    points(x, y)
    points(x, y2)
    arrows(x, y, x, y2, length=0)
    dev.off()
    maxTorque <- max(y2, na.rm=TRUE)
    minTorque <- min(y, na.rm=TRUE)
    print(paste("Max and min torque for ", maneuver, " = ", maxTorque, " and ",
    minTorque))
    }
