# Analyzes the data from the bicycle torque wrench experiments performed on
# April 6, 2010 and creates some plots of the results.

rm(list = ls())

library(ggplot2)
library(reshape2)

"../figures" -> figDir
"../data" -> dataDir

# read the data
data <- read.csv(file.path(dataDir, 'torque-wrench-data.txt'))

# miles per hour to meters per second
mph2mps <- 0.44704
# inch pounds to newton meters
inchlb2nm <- 0.112984829

data$AverageSpeed <- mph2mps * (data$MaxSpeed + data$MinSpeed) / 2
data$MaxTorque <- inchlb2nm * data$MaxTorque

# combine the maximum and minimum torques into one column
melted <- melt(data, measure.vars=c("MaxTorque", "MinTorque"))

# histogram of the average run speeds
plot <- qplot(data=data, x=AverageSpeed, binwidth=0.5)
plot <- plot + xlab('Speed [m/s]')
plot <- plot + ylab('Number')
plot <- plot + ggtitle('Number of Trials at Each Average Speed')
ggsave(file.path(figDir, "twrench-speed-histogram.pdf"), width=4, height=4)

# histogram of the max/min torque values
plot <- qplot(data=melted, x=abs(value), binwidth=0.5)
plot <- plot + xlab("Absolute value of max and min torques [Nm]")
plot <- plot + ylab('Number')
plot <- plot + ggtitle("Histogram of Torque Values")
ggsave(file.path(figDir, "twrench-torque-histogram.pdf"), width=4, height=4)

# torque versus speed for all the runs
plot <- ggplot(melted, aes(x=AverageSpeed, value, color=Maneuver))
plot <- plot + geom_point(size=2)
plot <- plot + xlab('Speed [m/s]')
plot <- plot + ylab('Torque [Nm]')
plot <- plot + ggtitle('Max and Min Torques as a \nFunction of Average Speed')
# plot + facet_grid(. ~ Maneuver)
ggsave(file.path(figDir, "twrench-torque-speed.pdf"), width=6, height=4)

# max torque versus speed for all the runs
plot <- ggplot(data, aes(x=AverageSpeed, MaxTorque, color=Maneuver))
plot <- plot + geom_point(size=2)
plot <- plot + geom_smooth(method="lm")
plot <- plot + xlab('Speed [m/s]')
plot <- plot + ylab('Torque [Nm]')
plot <- plot + ggtitle('Max Torque as a \nFunction of Average Speed')
ggsave(file.path(figDir, "twrench-max-torque-speed.pdf"), width=4, height=4)

# min torque versus speed for all the runs
plot <- ggplot(data, aes(x=AverageSpeed, MinTorque, color=Maneuver))
plot <- plot + geom_point(size=2)
plot <- plot + geom_smooth(method="lm")
plot <- plot + xlab('Speed [m/s]')
plot <- plot + ylab('Torque [Nm]')
plot <- plot + ggtitle('Min Torque as a \nFunction of Average Speed')
ggsave(file.path(figDir, "twrench-min-torque-speed.pdf"), width=4, height=4)

# show speed vs torque for each maneuver
maneuvers <- unique(data$Maneuver)
print(maneuvers)
for(maneuver in levels(maneuvers)){
    print(maneuver)
    pdf(file.path(figDir, paste("twrench-", maneuver, ".pdf", sep="")))
    x <- subset(data$AverageSpeed, data$Maneuver==maneuver)
    y <- subset(data$MinTorque, data$Maneuver==maneuver)
    y2 <- subset(data$MaxTorque, data$Maneuver==maneuver)
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
