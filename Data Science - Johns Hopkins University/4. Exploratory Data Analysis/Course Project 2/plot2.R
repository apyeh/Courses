# Exploratory Data Analysis
# Course Project 2
# by Andrew Yeh

## Plot2.R constructs a plot (using base plotting system) to answer the following question:

## Question 2:
## "Have total emissions from PM2.5 decreased in Baltimore City, Maryland (fips == "24510") from 1999 to 2008?"

## Read in files

if(!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}

## Subset emissions data pertaining only to Baltimore, MD (fips = 24510)
NEI_Baltimore <- NEI[NEI$fips == 24510,]

## Calculate total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008

emissions_sum <- tapply(NEI_Baltimore$Emissions, NEI_Baltimore$year, sum)

## Generate barplot of total emissions per year
barplot(emissions_sum, col = "blue", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", main = "PM2.5 Emissions in Baltimore, MD, 1999-2008")
dev.copy(png, file = "plot2.png")
dev.off()