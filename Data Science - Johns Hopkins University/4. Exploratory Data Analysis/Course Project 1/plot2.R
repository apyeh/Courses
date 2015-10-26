## Plot2.R creates graph of "Global Active Power" usage over the course of two days (2/1/07 & 2/2/07)

## Read in data for only the days that are of interest, i.e., 2/1/2007 & 2/2/2007
data <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", skip = 66637, nrows = 2880,
        header = F, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
        "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## Convert Date from character to date format
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

## Combine Date and Time and convert via strptime()
data$DateTime <- strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

## Plot "Global active power" vs. "time"
par(cex.lab = 0.7, mar = c(5,5.5,4,2))
plot(data$DateTime, data$Global_active_power, type="l", xlab = "", ylab = "Global Active Power (kilowatts)")

## save to png format
dev.copy(png, file = "plot2.png")
dev.off()