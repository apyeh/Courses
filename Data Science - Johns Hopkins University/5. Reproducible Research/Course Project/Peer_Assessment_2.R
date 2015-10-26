
#if(!is.element("repdata_data_StormData.csv.bz2", list.files())) {
#        URL <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
#        download.file(URL, "./repdata_data_StormData.csv.bz2", method="curl")
# }

# if(!exists("data")) {
#        data <- read.csv("./repdata_data_StormData.csv.bz2")
#}

load("repdata_data_StormData.RData")



## Check if dplyr package is installed.
if(!is.element("dplyr", installed.packages()[,1])) {
        install.packages("dplyr")
}
library(dplyr)

## Check if ggplot2 package is installed.
if(!is.element("ggplot2", installed.packages()[,1])) {
        install.packages("ggplot2")
}
library(ggplot2)

## Check if knitr package is installed.
if(!is.element("knitr", installed.packages()[,1])) {
        install.packages("knitr")
}
library(knitr)

## Check if reshape2 package is installed.
if(!is.element("reshape2", installed.packages()[,1])) {
        install.packages("reshape2")
}
library(reshape2)


## --------------------------------------------------------------------------------------------

## View(data %>% group_by(EVTYPE) %>% summarise(n=n()))

## Define population health as being negatively affected by a storm event if there were any fatalities or injuries  
## Subset data to include only rows where there are fatalities or injuries or property or crop damage.

## Check out data
str(data)


attach(data)

data_subset <- data[data$FATALITIES > 0 | data$INJURIES > 0 | data$PROPDMG > 0 | data$CROPDMG > 0,]

## Subset data to weather events which caused either fatalities or injuries.
# data_population_health <- data[data$FATALITIES > 0 | data$INJURIES > 0,]
# data_population_health <- data_subset[FATALITIES > 0 | INJURIES > 0,]

## Subset data to weather events which caused either crop or property damage.
# data_economics <- data[PROPDMG > 0 | CROPDMG > 0,]


## Check the event types
unique(data_subset$EVTYPE)

## --------------------------------------------------------------------------------------------

## Tidy property damage columns

## Check what's in the property damage exponent column
unique(PROPDMGEXP)


## Check crop damage exponent column after conversion to upper case
## unique(PROPDMGEXP)

## Convert PROPDMGEXP into correpsonding exponent and enter that into a new column PropDmgMultiplier
## These conversion factors were based on a great detailed analysis of these factors found at the following link:
## https://rstudio-pubs-static.s3.amazonaws.com/58957_37b6723ee52b455990e149edde45e5b6.html

attach(data_subset)

data_subset$PropDmgMultiplier[PROPDMGEXP == "H" | PROPDMGEXP == "h"] <- 1e+02
data_subset$PropDmgMultiplier[PROPDMGEXP == "K" | PROPDMGEXP == "k"] <- 1e+03
data_subset$PropDmgMultiplier[PROPDMGEXP == "M" | PROPDMGEXP == "m"] <- 1e+06
data_subset$PropDmgMultiplier[PROPDMGEXP == "B" | PROPDMGEXP == "b"] <- 1e+09
data_subset$PropDmgMultiplier[PROPDMGEXP == "0"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "1"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "2"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "3"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "4"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "5"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "6"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "7"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == "8"] <- 10
data_subset$PropDmgMultiplier[PROPDMGEXP == ""] <- 0
data_subset$PropDmgMultiplier[PROPDMGEXP == "?"] <- 0
data_subset$PropDmgMultiplier[PROPDMGEXP == "+"] <- 1
data_subset$PropDmgMultiplier[PROPDMGEXP == "-"] <- 0

## Calculate property damage for each event by multiplying property damage times
## property damage multiplier and enter into new column PropDmgFinal

# data_subset$PropDmgFinal <- data_subset$PROPDMG * !is.na(data_subset$PropDmgMultiplier)

data_subset$PropDmgFinal <- data_subset$PROPDMG * data_subset$PropDmgMultiplier



## --------------------------------------------------------------------------------------------

## Tidy crop damage columns

## Check what's in the crop damage exponent column
unique(CROPDMGEXP)

## Convert all characters in crop damage exponenet column to upper case
## data_subset$CROPDMGEXP <- toupper(data_subset$CROPDMGEXP)

## Check crop damage exponent column after conversion to upper case
## unique(data_subset$CROPDMGEXP)

## Convert CROPDMGEXP into correpsonding exponent and enter that into a new column CropDmgMultiplier

data_subset$CropDmgMultiplier[CROPDMGEXP == "K" | CROPDMGEXP == "k"] <- 1e+03
data_subset$CropDmgMultiplier[CROPDMGEXP == "M" | CROPDMGEXP == "m"] <- 1e+06
data_subset$CropDmgMultiplier[CROPDMGEXP == "B"] <- 1e+09
data_subset$CropDmgMultiplier[CROPDMGEXP == "0"] <- 10
data_subset$CropDmgMultiplier[CROPDMGEXP == "2"] <- 10
data_subset$CropDmgMultiplier[CROPDMGEXP == ""] <- 0
data_subset$CropDmgMultiplier[PROPDMGEXP == "?"] <- 0

## Calculate property damage for each event by multiplying property damage times
## property damage multiplier and enter into new column CropDmgFinal

# data_subset$CropDmgFinal <- data_subset$CROPDMG * !is.na(data_subset$CropDmgMultiplier)

data_subset$CropDmgFinal <- data_subset$CROPDMG * data_subset$CropDmgMultiplier



## data_subset[PROPDMGEXP == "-", c("EVTYPE", "PROPDMG", "PROPDMGEXP", "PropDmgExpNum", "PropDmgFinal")]  

## --------------------------------------------------------------------------------------------

data_subset_melt <- melt(data_subset, id = "EVTYPE", measure.vars = c("FATALITIES", "INJURIES", "PropDmgFinal", "CropDmgFinal"))

data_subset_dcast <- dcast(data_subset_melt, EVTYPE ~ variable, sum)


## --------------------------------------------------------------------------------------------

## Group event types into one of the 48 listed categories in the Storm Data Event Table 2.1.1
## Event types for which a category could not be determined were placed in a category called 'Other'

event_types <- unique(data_subset_dcast$EVTYPE)
print(event_types)

## Convert all EVTYPE's to upper case since some of the EVTYPE's are in lower case.
data_subset_dcast$EVTYPE <- toupper(data_subset_dcast$EVTYPE)


## 48 Event
## Astronomical Low Tide
astronimical_low_tide <- grep('^ASTRONOMICAL LOW TIDE', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% astronimical_low_tide] <- "Astronomical Low Tide"

## Avalanche
avalanche <- grep('^AVALANC', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% avalanche] <- "Avalanche"

## Blizzard
blizzard <- grep('^BLIZZARD|GROUND BLIZZARD', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% blizzard] <- "Blizzard"

## Coastal Flood
coastal_flood <- grep('COASTAL', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% coastal_flood] <- "Coastal Flood"

## Cold/Wind Chill
cold_wind_chill <- intersect(grep('^COLD$|^COLD|RECORD COLD|UNSEASONABLY COLD|LOW TEMPERATURE|HYPOTHERMIA|HYPERTHERMIA|EXTENDED COLD|COOL AND WET|UNSEASONABLE COLD',
        data_subset_dcast$EVTYPE, value = TRUE,  ignore.case = TRUE), grep('COLD AIR TORNADO', data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% cold_wind_chill] <- "Cold/Wind Chill"

## Dense Fog
dense_fog <- grep('DENSE FOG|^FOG$', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% dense_fog] <- "Dense Fog"

## Dense Smoke
dense_smoke <- grep('DENSE SMOKE', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% dense_smoke] <- "Dense Smoke"

## Drought
drought <- grep('DROUGHT', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% drought] <- "Drought"

## Dust Devil
dust_devil <- grep("DUST DEVIL", data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% dust_devil] <- "Dust Devil"

## Dust Storm
dust_storm <- grep('DUST STORM|DUST$', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% dust_storm] <- "Dust Storm"

## Excessive Heat
excessive_heat <- intersect(grep('EXCESSIVE HEAT|EXTREME HEAT|RECORD HEAT|UNSEASONABLY WARM', data_subset_dcast$EVTYPE, value = TRUE),
        grep('DROUGHT/EXCESSIVE HEAT', data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% excessive_heat] <- "Excessive Heat" 

## Extreme Cold
extreme_cold <- grep('EXTREME COLD|EXTREME WIND|SNOW/ BITTER COLD', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% extreme_cold] <- "Extreme Cold/Wind Chill"

## Flash Flood
flash_flood <- grep('FLASH|LANDSLIDE|MUDSLIDE|MUD SLIDE|RAPIDLY RISING WATER', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% flash_flood] <- "Flash Flood"

## Flood
flood <- intersect(grep('FLOOD|URBAN/SML STREAM FLD|URBAN*.*SMALL', data_subset_dcast$EVTYPE, value = TRUE),
        grep('COASTAL|LAKE *.* FLOOD|FLASH|^HEAVY RAIN|^HEAVY SNOW|THUNDERSTORM WINDS',
        data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% flood] <- "Flood"

## Freezing Fog
freezing_fog <- grep('FOG AND COLD TEMPERATURES|FREEZING FOG', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% freezing_fog] <- "Freezing Fog"

## Frost/Freeze
frost_freeze <- grep('FROST|FREEZE', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% frost_freeze] <- "Frost/Freeze"

## Funnel Cloud
funnel_cloud <- grep('FUNNEL CLOUD', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% funnel_cloud] <- "Funnel Cloud"

## Hail
hail <- grep('^HAIL|SMALL HAIL', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% hail] <- "Hail"

## Heat
heat <- intersect(grep('^HEAT|WARM WEATHER', data_subset_dcast$EVTYPE, value = TRUE),
        grep('DROUGHT', data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% heat] <- "Heat" 

## Heavy Rain
heavy_rain_evtype <- c('^HEAVY RAIN|^RAIN|EXCESSIVE RAINFALL|HEAVY PRECIPITATION|RECORD RAINFALL|EXCESSIVE WETNESS|HEAVY SHOWER|HVY RAIN|TORRENTIAL RAINFALL|UNSEASONAL RAIN')
heavy_rain <- grep(heavy_rain_evtype, data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% heavy_rain] <- "Heavy Rain"

## Heavy Snow
heavy_snow <- intersect(grep('HEAVY SNOW|^SNOW$|EXCESSIVE SNOW|RECORD SNOW|SNOW/COLD|HEAVY SNOW AND HIGH WINDS|SNOW SQUALL',
        data_subset_dcast$EVTYPE, value = TRUE), grep('^HIGH WIND', data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% heavy_snow] <- "Heavy Snow"

## High Surf
high_surf <- grep('HIGH SURF|^HEAVY SURF$|ROUGH SURF|HAZARDOUS SURF|HEAVY SURF AND WIND', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% high_surf] <- "High Surf"

## High Wind
high_wind <- grep('^HIGH WIND|SNOW/HIGH WINDS|NON*.*TSTM WIND|WHIRLWIND|HIGH  WINDS|SEVERE TURBULENCE', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% high_wind] <- "High Wind"

## Hurricane
hurricane <- grep('HURRICANE|TYPHOON', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% hurricane] <- "Hurricane/Typhoon"

## Ice Storm
ice_storm <- grep('^ICE|GLAZE|ICY|SNOW AND ICE|SNOW/ICE STORM', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% ice_storm] <- "Ice Storm"

## Lake Effect Snow
lake_effect_snow <- grep('LAKE *.* SNOW', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% lake_effect_snow] <- "Lake Effect Snow"

## Lakeshore Flood
lakeshore_flood <- grep('LAKE *.* FLOOD', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% lakeshore_flood] <- "Lakeshore Flood"

## Lightning
lightning <- grep('^LIGHTNING|LIGHTING|LIGNTNING', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% lightning] <- "Lightning"

## Marine Hail
marine_hail <- grep('MARINE HAIL', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% marine_hail] <- "Marine Hail"

## Marine High Wind
marine_high_wind <- grep('MARINE HIGH WIND', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% marine_high_wind] <- "Marine High Wind"

## Marine Strong Wind
marine_strong_wind <- grep('MARINE STRONG|ROUGH SEAS', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% marine_strong_wind] <- "Marine Strong Wind"

## Marine Thunderstorm Wind
marine_thunderstorm_wind <- grep('MARINE T*.*M WIND', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% marine_thunderstorm_wind] <- "Marine Thunderstorm Wind"

## Rip Current
rip_current <- grep('RIP CURRENT', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% rip_current] <- "Rip Current"

## Seiche
seiche <- grep('SEICHE', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% seiche] <- "Seiche"

## Sleet
sleet <- intersect(grep('SLEET|FREEZING RAIN|FREEZING DRIZZLE|BLACK ICE', data_subset_dcast$EVTYPE, value = TRUE),
        grep('^HEAVY SNOW', data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% sleet] <- "Sleet"

## Storm Surge/Tide
storm_surge_tide <- intersect(grep('SURGE|TIDE|ASTRONOMICAL HIGH TIDE|HIGH SEAS|HIGH WATER|HEAVY SEAS|HIGH SWELLS|HIGH WAVES|HEAVY SWELLS', 
        data_subset_dcast$EVTYPE, value = TRUE), grep('^ASTRONOMICAL LOW TIDE', data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% storm_surge_tide] <- "Storm Surge/Tide"

## Strong Wind
strong_winds <- grep('^STRONG WIND|^ICE/STRONG WINDS|^WIND|GUSTY|NON-SEVERE WIND DAMAGE|GRADIENT WIND', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% strong_winds] <- "Strong Wind"

## Thunderstorm Wind
thunderstorm <- intersect(grep('THUNDER|TSTM|MICROBURST|TUNDER|THUDERSTORM|STORM FORCE WINDS|THUNERSTORM|THUNDEERSTORM|MIRCOBURST|GUSTNADO|DOWNBURST',
        data_subset_dcast$EVTYPE, value = TRUE), grep("NON|MARINE|^FLASH", data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% thunderstorm] <- "Thunderstorm Wind" 

## Tornado
tornado <- intersect(grep('TORNADO|TORNDAO', data_subset_dcast$EVTYPE, value = TRUE),
        grep("WATERSPOUT", data_subset_dcast$EVTYPE, invert = TRUE, value = TRUE))
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% tornado] <- "Tornado" 

## Tropical Depression
tropical_depression <- grep('TROPICAL DEPRESSION', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% tropical_depression] <- "Tropical Depression" 

## Tropical Storm
tropical_storm <- grep('TROPICAL STORM', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% tropical_storm] <- "Tropical Storm"

## Tsunami
tsunami <- grep('TSUNAMI', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% tsunami] <- "Tsunami"

## Volcanic Ash
volcanic_ash <- grep('VOLCANIC ASH', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% volcanic_ash] <- "Volcanic Ash"

## Waterspout
waterspout <- grep('WATERSPOUT', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% waterspout] <- "Waterspout"

## Wildfire
wildfire <- grep('FIRE', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% wildfire] <- "Wildfire"

## Winter Storm
winter_storm <- grep('^WINTER STORM|HEAVY MIX', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% winter_storm] <- "Winter Storm"

## Winter Weather
winter_weather <- grep('WINTER WEATHER|WINTRY MIX|BLOWING SNOW|FALLING SNOW/ICE|LIGHT SNOW|LATE SEASON SNOW|SNOW/ ICE|^SNOW/ICE$',
        data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% winter_weather] <- "Winter Weather"

## Other
other <- grep('BEACH EROSION|DAM BREAK|DROWNING|FREEZING SPRAY|^HIGH$|LANDSLUMP|LANDSPOUT|MARINE ACCIDENT|MARINE MISHAP|MIXED PRECIP|^OTHER$|ROCK SLIDE|ROGUE WAVE|SNOW ACCUMULATION', data_subset_dcast$EVTYPE, value = TRUE)
data_subset_dcast$EventCategory[data_subset_dcast$EVTYPE %in% other] <- "Other"


## --------------------------------------------------------------------------------------------

## Create new summary dataframe that has 48 storm event categories and the corresponding
## economic and population health impact

data_summary <- data_subset_dcast

## Remove old EVTYPE column
data_summary$EVTYPE <- NULL

colnames(data_summary)

## Reorder columns
data_summary <- data_summary[,c(5,1,2,3,4)]

## Rename columns
names(data_summary) <- c("EventCategory", "Fatalities", "Injuries", "PropertyDamage", "CropDamage")

## Sum fatalities, injuries, property damage, and crop damage for each of 48 storm event categories
data_summary <- melt(data_summary, id = "EventCategory", measure.vars = c("Fatalities", "Injuries", "PropertyDamage", "CropDamage"))
data_summary <- dcast(data_summary, EventCategory ~ variable, sum)


## Sum fatalities and injuries to determine total population health impact and sum property and crop damages
## to determine total economic costs

data_summary$PopulationHealth <- rowSums(data_summary[,c(2:3)])
data_summary$EconomicCosts <- rowSums(data_summary[,c(4:5)])

## Reorder columns
data_summary <- data_summary[,c(1,2,3,6,4,5,7)]

## Rank storm event categories based on population health impact

## 48 storm event categories ranked according to number of fatalities
fatalities_ranked <- data_summary[order(-data_summary$Fatalities), c(1,2)] %>% mutate(Rank = dense_rank(desc(Fatalities)))
fatalities_ranked <- fatalities_ranked[,c(3,1,2)]
fatalities_ranked

## Top 10 storm event categories causing the most number of fatalities
fatalities_top10 <- fatalities_ranked[1:10,]
        
## 48 storm event categories ranked according to number of injuries
injuries_ranked <- data_summary[order(-data_summary$Injuries), c(1,3)] %>% mutate(Rank = dense_rank(desc(Injuries)))
injuries_ranked <- injuries_ranked[,c(3,1,2)]
injuries_ranked

## Top 10 storm event categories causing the most number of injuries
injuries_top10 <- injuries_ranked[1:10,]

## 48 storm event categories ranked according to their impact on population health
pophealth_ranked <- data_summary[order(-data_summary$PopulationHealth), c(1:4)] %>% mutate(Rank = dense_rank(desc(PopulationHealth)))
pophealth_ranked <- pophealth_ranked[,c(5,1,2,3,4)]
pophealth_ranked

## Top 10 storm event categories causing the most impact on population health
pophealth_top10 <- pophealth_ranked[1:10,]

## Rank storm event categories based on economic costs impact

## 48 storm event categories ranked according to property damage
propdmg_ranked <- data_summary[order(-data_summary$PropertyDamage), c(1,5)] %>% mutate(Rank = dense_rank(desc(PropertyDamage)))
propdmg_ranked <- propdmg_ranked[,c(3,1,2)]
propdmg_ranked

## Top 10 storm event categories causing the most property damage
propdmg_top10 <- propdmg_ranked[1:10,]

## 48 storm event categories ranked according to crop damage
cropdmg_ranked <- data_summary[order(-data_summary$CropDamage), c(1,6)] %>% mutate(Rank = dense_rank(desc(CropDamage)))
cropdmg_ranked <- cropdmg_ranked[,c(3,1,2)]
cropdmg_ranked

## Top 10 storm event categories causing the most crop damage
cropdmg_top10 <- cropdmg_ranked[1:10,]

## 48 storm event categories ranked according to total economic costs
econcosts_ranked <- data_summary[order(-data_summary$EconomicCosts), c(1,5:7)] %>% mutate(Rank = dense_rank(desc(EconomicCosts)))
econcosts_ranked <- econcosts_ranked[,c(5,1,2,3,4)]
econcosts_ranked

## Top 10 storm event categories causing the greatest economic costs
econcosts_top10 <- econcosts_ranked[1:10,]

## --------------------------------------------------------------------------------------------

## Generate barplot of top 10 storm events impacting U.S. population health using ggplot2

pophealth_top10_melt <- melt(pophealth_top10, id.var = "EventCategory", measure.vars = c("Fatalities", "Injuries", "PopulationHealth"))
levels(pophealth_top10_melt$variable) <- c("Fatalities", "Injuries", "Fatalities + Injuries")

plot1 <- ggplot(pophealth_top10_melt, aes(x = reorder(EventCategory, -value), y = value))

print(plot1 + geom_bar(aes(fill = EventCategory), stat = "identity") + 
        labs(title = "Top 10 Storm Events Impacting U.S. Population Health \nBetween 1950-2011", x = "Storm Event", y = "Human fatalities and/or Injuries (# of people)") +
        theme(axis.text.x = element_text(angle=90, size=10, vjust=0.5), panel.margin = unit(1, "lines")) +
        facet_wrap(~ variable, ncol = 3))

## --------------------------------------------------------------------------------------------

## Generate barplot of top 10 storm events causing most economic damage in the U.S.

econcosts_top10_melt <- melt(econcosts_top10, id.var = "EventCategory", measure.vars = c("PropertyDamage", "CropDamage", "EconomicCosts"))
levels(econcosts_top10_melt$variable) <- c("Property Damage", "Crop Damage", "Property + Crop Damage")

plot2 <- ggplot(econcosts_top10_melt, aes(x = reorder(EventCategory, -value), y = value/1e+09))

print(plot2 + geom_bar(aes(fill = EventCategory), stat = "identity") + 
        labs(title = "Top 10 Storm Events Causing Most Economic Damage \n in the U.S. Between 1950-2011", x = "Storm Event", y = "Damage Costs (USD in Billions)") +
        theme(axis.text.x = element_text(angle=90, size=10, vjust=0.5), panel.margin = unit(1, "lines")) +
        facet_wrap(~ variable, ncol = 3))

