## Plot3.R

## Read in data for only the days that are of interest, i.e., 2/1/2007 & 2/2/2007
data <- read.table("household_power_consumption.txt", sep = ";", na.strings = "?", skip = 66637, nrows = 2880,
        header = F, col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage",
        "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## Convert Date from character to date format
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")

## Combine Date and Time and convert via strptime()
data$DateTime <- strptime(paste(data$Date, data$Time), format = "%Y-%m-%d %H:%M:%S")

## Plot "Energy sub metering" vs. "time"
par(cex.lab = 0.7, mar = c(5,5.5,4,2))
plot(data$DateTime, data$Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")
points(data$DateTime, data$Sub_metering_2, type="l", xlab = "", col = "red")
points(data$DateTime, data$Sub_metering_3, type="l", xlab = "", col = "blue")

## Add legend to plot
legend_text <- c(colnames(data[7]), colnames(data[8]), colnames(data[9]))
legend_line <- c(1, 1, 1)
legend_line_color <- c("black", "red", "blue")
legend("topright", legend_text, lty = legend_line, col = legend_line_color, cex = 0.7)

## Save to png format
dev.copy(png, file = "plot3.png")
dev.off()