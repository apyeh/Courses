## Plot4.R constructs a plot to address the question below

## Question 4:
## Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

## Read in files

if(!exists("NEI")) {
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")) {
        SCC <- readRDS("Source_Classification_Code.rds")
}

## Subset NEI data that contains "coal" in the EI.Sector
coal_labels <- grep("coal|Coal", SCC[,4], value=TRUE)
SCC_coal <- SCC[SCC$EI.Sector %in% coal_labels,]
NEI_coal <- NEI[NEI$SCC %in% SCC_coal$SCC,]


## Calculate total PM2.5 emission in the U.S. from coal-combustion sources for each
## of the years 1999, 2002, 2005, and 2008
emissions_sum <- tapply(NEI_coal$Emissions, NEI_coal$year, sum)

## Generate barplot of total PM2.5 emissions per year from coal-combustion sources
barplot(emissions_sum, col = "green", xlab = "Year", ylab = "Total PM2.5 Emissions (tons)",
        main = "PM2.5 Emissions from Coal Combusion Sources \nin the U.S., 1999-2008")
dev.copy(png, file = "plot4.png")
dev.off()