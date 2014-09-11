# Filename: torque-wrench.R
# Date: April 6, 2010
# Author: Jason Moore
# Description: Analyzes the data from the bicycle torque wrench experiments
# performed on April 6, 2010.

rm(list = ls())

"../figures" -> figDir
"../data" -> dataDir

# read the data
data <- read.csv(file.path(dataDir, 'torque-wrench-data.txt'))

# miles per hour to meters per second
mph2mps <- 0.44704
# inch pounds to newton meters
inchlb2nm <- 0.112984829

averageSpeed <- (data$MaxSpeed + data$MinSpeed) / 2

# histogram of the average run speeds
pdf(file.path(figDir, "twrench-speed-histogram.pdf"),
    width=4, height=4, pointsize=10)
hist(averageSpeed)
dev.off()

# histogram of the max/min torque values
pdf(file.path(figDir, "twrench-torque-histogram.pdf"),
    width=4, height=4, pointsize=10)
hist(abs(c(data$MinTorque, inchlb2nm * data$MaxTorque)),
     main ="Histogram of Torque Values",
     xlab="Absolute value of max and min torques [Nm]",
     breaks=25)
dev.off()

# torque versus speed for all the runs
pdf(file.path(figDir, "twrench-torque-speed.pdf"),
    width=4, height=4, pointsize=10)
plot(0:10,-5:5, type="n", main="Max and Min Torques as a Function of Speed",
xlab="Speed [m/s]", ylab="Torque [Nm]")
points(mph2mps * averageSpeed, data$MinTorque, pch=19)
points(mph2mps * averageSpeed, inchlb2nm * data$MaxTorque, pch=23)
dev.off()

maneuvers <- unique(data$Maneuver)
print(maneuvers)
for(maneuver in levels(maneuvers)){
    print(maneuver)
    pdf(file.path(figDir, paste("twrench-", maneuver, ".pdf", sep="")))
    x <- subset(mph2mps*averageSpeed, data$Maneuver==maneuver)
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
