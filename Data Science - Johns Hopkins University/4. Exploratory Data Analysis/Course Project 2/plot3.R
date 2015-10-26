# Exploratory Data Analysis
# Course Project 2
# by Andrew Yeh

## Plot3.R constructs a plot (using ggplot2 system) to answer the question below.

## Question 3:
## Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
## which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
## Which have seen increases in emissions from 1999–2008?

## Read in files

if(!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}

if(!is.element("reshape2", installed.packages()[,1])) {
        install.packages("reshape2")
}
library(reshape2)

## Subset emissions data pertaining only to Baltimore, MD (fips = 24510)
NEI_Baltimore <- NEI[NEI$fips == 24510,]

## Calculate total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008
emissions_sum <- tapply(NEI_Baltimore$Emissions, list(NEI_Baltimore$type, NEI_Baltimore$year), sum)
emissions_melt <- melt(emissions_sum)
names(emissions_melt) <- c("type", "year", "emissions")


## Generate barplot of total emissions per year using ggplot2
library(ggplot2)

p <- ggplot(emissions_melt, aes(x = factor(year), y = emissions))
print(p + geom_bar(aes(fill = type), stat = "identity") + facet_grid(. ~ type) +
        labs(title = "PM25 Emissions by Source Type, Baltimore, MD, 1999-2008",
        x = "Year", y = "Total PM25 Emissions (tons)") +
        theme(axis.text.x = element_text(angle=50, size=10, vjust=0.5)))

dev.copy(png, file = "plot3.png")
dev.off()