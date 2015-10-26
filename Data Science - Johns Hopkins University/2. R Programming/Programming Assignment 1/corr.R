# R Programming
# Programming Assignment 1, Part 3
# by Andrew Yeh

# “Write a function that takes a directory of data files and a threshold for complete cases and calculates
# the correlation between sulfate and nitrate for monitor locations where the number of completely observed
# cases (on all variables) is greater than the threshold. The function should return a vector of correlations
# for the monitors that meet the threshold requirement. If no monitors meet the threshold requirement, then the
# function should return a numeric vector of length 0."


corr <- function(directory, threshold = 0) {
        files_list <- list.files(directory, full.names=T)       ##  creates a list of files
        correlation <- c()                                      ##  creates an empty nobs vector
        dat <- data.frame()                                     ##  creates an empty data frame
        for (i in 1:332) {                                      ##  loops thru each file
                dat <- read.csv(files_list[i])
                ncomplete <- sum(complete.cases(dat))
                if (ncomplete >= threshold) {
                        dat_subset <- dat[which(dat[,"ID"] == i),] 
                        correlation <- append(correlation ,cor(dat_subset$sulfate, dat_subset$nitrate,
                        use="pairwise.complete.obs"))           ## appends correlations
                }
        }
        return(correlation)
}