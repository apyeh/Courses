## Plot4.R plots 4 plots together.
## Top left plot is of global active power vs. time
## Top right plot is of voltage usage vs. time
## Bottom left plot is of sub-metered energy usage vs. time
## Bottom right plot is of global reactive power usage vs. time

## Read in data for only the days that are of interest, i.e., 2/1/2007 & 2/2/2007
data <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", skip = 66637, nrows = 2880,
        header = F, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
        "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## Convert Date from character to date format
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

## Combine Date and Time and convert via strptime()
data$DateTime <- strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

par(mfcol = c(2,2), mar = c(5, 5, 3, 2))

## Plot "Global active power" vs. "time"

plot(data$DateTime, data$Global_active_power, type="l", xlab = "", ylab = "Global Active Power")

## ==============================================================================================

## Plot "Energy sub metering" vs. "time"

plot(data$DateTime, data$Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")
points(data$DateTime, data$Sub_metering_2, type="l", xlab = "", col = "red")
points(data$DateTime, data$Sub_metering_3, type="l", xlab = "", col = "blue")

## Add legend to plot
legend_text <- c(colnames(data[7]), colnames(data[8]), colnames(data[9]))
legend_line <- c(1, 1, 1)
legend_line_color <- c("black", "red", "blue")
legend("topright", legend_text, lty = legend_line, col = legend_line_color, cex = 0.5, bty ="n")

## ==============================================================================================

##  Plot "Voltage" usage vs. time

plot(data$DateTime, data$Voltage, type="l", xlab = "datetime", ylab = colnames(data[5]))


## ==============================================================================================

## Plot "Global reactive power" usage vs. time

plot(data$DateTime, data$Global_reactive_power, type="l", xlab = "datetime", ylab = colnames(data[4]))

## Save to png format
dev.copy(png, file = "plot4.png")
dev.off()