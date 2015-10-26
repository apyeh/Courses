# R Programming
# Programming Assignment 1, Part 2
# by Andrew Yeh

# Write a function that reads a directory full of files and reports the number of completely observed cases
# in each data file. The function should return a data frame where the first column is the name of the file
# and the second column is the number of complete cases.

complete <- function(directory, id = 1:332) {
        files_list <- list.files(directory, full.names=T)       ##  creates a list of files
        nobs <- c()                                             ##  creates an empty nobs vector
        dat <- data.frame()                                     ##  creates an empty data frame
        for (i in id) {                                         ##  loops thru files, rbinding them together
                dat <- rbind(dat, read.csv(files_list[i]))
                dat_subset <- dat[which(dat[,"ID"] == i),]
                nobs <- append(nobs,sum(complete.cases(dat_subset)))    ## appends nobs  
        }        
        table <- data.frame(id,nobs)
        print(table)
}