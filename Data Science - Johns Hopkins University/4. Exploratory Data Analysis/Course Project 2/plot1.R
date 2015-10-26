# Exploratory Data Analysis
# Course Project 2
# by Andrew Yeh

## Plot1.R constructs a plot (using base plotting system) to answer the question below

## Question 1:
## "Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?"

## Read in files

if(!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}

## Calculate total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008

emissions_sum <- tapply(NEI$Emissions, NEI$year, sum)

## Generate barplot of total emissions per year
barplot(emissions_sum, col = "red", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)", main = "PM2.5 Emissions in the U.S., 1999-2008")
dev.copy(png, file = "plot1.png")
dev.off()