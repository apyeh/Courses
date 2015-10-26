## Plot6.R constructs a plot (using ggplot2 system) to address the question below.

## Question 6:
## Compare emissions from motor vehicle sources in Baltimore City (fips =="24510") with emissions from
## motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater
## changes over time in motor vehicle emissions?
##
## Note: For the purposes of this question, I've defined motor vehicles to be any vehicle
## powered by a motor that is either onroad or offroad. This includes cars, trucks, motorcycles,
## recreational, construction, industrial, lawn & garden, agricultural, mining, and logging equipment.

## Read in files

if(!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}

## Check if car package is installed.
## A function (recode) from this package will be used to add city names.

if(!is.element("car", installed.packages()[,1])) {
        install.packages("car")
}
library(car)

## Check if reshape2 package is installed.
## A function (melt) from this package will be used to reshape data.

if(!is.element("reshape2", installed.packages()[,1])) {
        install.packages("reshape2")
}
library(reshape2)

## Based on my definition of motor vehicle above and in looking at the Source Classification Code Table
## in Excel, the best column to search for vehicles appears to be SCC.Level.Two. Subset NEI data that contains
## "Vehicle" in the SCC.Level.Two variable. This encompasses both Onroad and Nonroad vehicles.

vehicle_labels <- grep("Vehicle|vehicle", SCC$SCC.Level.Two, value = TRUE)
SCC_vehicle <- SCC[SCC$SCC.Level.Two %in% vehicle_labels,]
NEI_vehicle <- NEI[NEI$SCC %in% SCC_vehicle$SCC,]

## Subset emissions data pertaining to Baltimore, MD (fips = 24510) and Los Angeles County, CA (fips = 06037)
NEI_vehicle_Baltimore_LA <- NEI_vehicle[NEI_vehicle$fips %in% c("24510", "06037"),]

## Calculate total PM2.5 emission from motor vehicle sources in Baltimore, MD and Los Angeles County, CA
## for each of the years 1999, 2002, 2005, and 2008
emissions_sum <- tapply(NEI_vehicle_Baltimore_LA$Emissions, list(NEI_vehicle_Baltimore_LA$fips, NEI_vehicle_Baltimore_LA$year), sum)
emissions_melt <- melt(emissions_sum)
names(emissions_melt) <- c("fips", "year", "emissions")

## Add city names to data
Cities <- recode(emissions_melt[,1], "06037 = 'Los Angeles, CA'; 24510 = 'Baltimore, MD'")
emissions_data <- cbind(Cities, emissions_melt)

## Generate barplot of total emissions per year using ggplot2
library(ggplot2)

## factor() needed otherwise, years turn out to be 1998.5, 2001.5, etc. for some reason
p <- ggplot(emissions_data, aes(x = factor(year), y = emissions))

## stat = "identity" needed b/c otherwise, it'll graph the counts.
print(p + geom_bar(aes(fill = Cities), stat = "identity") + facet_grid(. ~ Cities) +
        labs(title = "PM2.5 Emissions from Motor Vehicle Sources \nin Baltimore, MD vs. Los Angeles, CA, 1999-2008",
        x = "Year", y = "Total PM25 Emissions (tons)") +
        theme(axis.text.x = element_text(angle=50, size=10, vjust=0.5)))

dev.copy(png, file = "plot6.png")
dev.off()