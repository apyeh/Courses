## Plot5.R constructs a plot to address the question below
##
## Question 5:
## How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
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

## Based on my definition of motor vehicle above and in looking at the Source Classification Code Table
## in Excel, the best column to search for vehicles appears to be SCC.Level.Two. Subset NEI data that contains
## "Vehicle" in the SCC.Level.Two variable. This encompasses both Onroad and Nonroad vehicles.

vehicle_labels <- grep("Vehicle|vehicle", SCC$SCC.Level.Two, value = TRUE)
SCC_vehicle <- SCC[SCC$SCC.Level.Two %in% vehicle_labels,]
NEI_vehicle <- NEI[NEI$SCC %in% SCC_vehicle$SCC,]

## Subset to Baltimore, MD

NEI_vehicle_Baltimore <- NEI_vehicle[NEI_vehicle$fips == 24510,]

## Calculate total PM2.5 emission from motor vehicle sources in Baltimore, MD for each
## of the years 1999, 2002, 2005, and 2008

emissions_sum <- tapply(NEI_vehicle_Baltimore$Emissions, NEI_vehicle_Baltimore$year, sum)

## Generate barplot of total PM2.5 emissions per year from coal-combustion sources

barplot(emissions_sum, col = "purple", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)",
        main = "PM2.5 Emissions from Motor Vehicle Sources \nin Baltimore, MD, 1999-2008")
dev.copy(png, file = "plot5.png")
dev.off()