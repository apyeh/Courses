## Plot1.R creates histogram for global active power

## Read in data for only the days that are of interest, i.e., 2/1/2007 & 2/2/2007
data <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", skip = 66637, nrows = 2880,
        header = F, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
        "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

## Create histogram
par(cex.axis = 0.75, cex.lab = 0.75, cex.main = 0.9, mar = c(5,5,4,2))
hist(data$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")
dev.copy(png, file = "plot1.png")
dev.off()