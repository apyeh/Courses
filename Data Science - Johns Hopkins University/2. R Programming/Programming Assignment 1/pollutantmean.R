# R Programming
# Programming Assignment 1, Part 1
# by Andrew Yeh

# "Write a function named 'pollutantmean' that calculates the mean of a pollutant (sulfate or nitrate) across
# a specified list of monitors. The function 'pollutantmean' takes three arguments: 'directory', 'pollutant',
# and 'id'. Given a vector monitor ID numbers, 'pollutantmean' reads that monitors' particulate matter data
# from the directory specified in the 'directory' argument and returns the mean of the pollutant across all
# of the monitors, ignoring any missing values coded as NA."


pollutantmean <- function(directory, pollutant, id = 1:332) {
        files_list <- list.files(directory, full.names=T)       ##  creates a list of files
        dat <- data.frame()                                     ##  creates an empty data frame
        for (i in id) {                                         ##  loops thru files, rbinding them together
                dat <- rbind(dat, read.csv(files_list[i]))
        }
        col <- if (pollutant == "sulfate") {
                2
        } else {
                3
        }
        mean(dat[, col], na.rm=T )
}