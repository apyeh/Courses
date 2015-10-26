# Getting and Cleaning Data
# Course Project

## run_analysis.R

## -----------------------------------------------------------------------------------------------------------
## Check if car package is installed.
## A function (recode) from this package will be used in step 3.

if(!is.element("car", installed.packages()[,1])) {
        install.packages("car")
}
library(car)

## Check if plyr package is installed.
## A function (ddply) from this package will be used in step 5.

if(!is.element("plyr", installed.packages()[,1])) {
        install.packages("plyr")
}
library(plyr)

## -----------------------------------------------------------------------------------------------------------
## Read in files from train and test folders

if(!exists("X_train")) X_train <- read.table("./train/X_train.txt")
if(!exists("y_train")) y_train <- read.table("./train/y_train.txt")
if(!exists("subject_train")) subject_train <- read.table("./train/subject_train.txt")

if(!exists("X_test")) X_test <- read.table("./test/X_test.txt")
if(!exists("y_test")) y_test <- read.table("./test/y_test.txt")
if(!exists("subject_test")) subject_test <- read.table("./test/subject_test.txt")

## -----------------------------------------------------------------------------------------------------------
## Step 1 - Merge the training and the test sets to create one data set.

X_merge <- rbind(X_train, X_test)

## Add variable names from features.txt to data set
features <- read.table("./features.txt")
names(X_merge) <- features[,2]

## -----------------------------------------------------------------------------------------------------------
## Step 2 - Extract only the measurements on the mean and standard deviation for each measurement. 

mean_std <- grep("mean|std", names(X_merge), value = TRUE)
X_merge_mean_std <- X_merge[,mean_std]

## Merge train and test labels
y_merge <- rbind(y_train, y_test)

## -----------------------------------------------------------------------------------------------------------
## Step 3 - Use descriptive activity names to name the activities in the data set

y_merge_descriptive <- recode(y_merge[,1], "1 = 'Walking'; 2 = 'Walking Upstairs'; 3 = 'Walking Downstairs';
        4 = 'Sitting'; 5 = 'Standing'; 6 = 'Laying'")

## -----------------------------------------------------------------------------------------------------------
## Merge train and test subjects
subject_merge <- rbind(subject_train, subject_test)

## Merge subjects and activity with data set
data_all <- cbind(subject_merge, y_merge_descriptive, X_merge_mean_std)

## -----------------------------------------------------------------------------------------------------------
## Step 4 -  labels the data set with descriptive variable names. 

names(data_all)[1:2] <- c("Subject", "Activity")

## -----------------------------------------------------------------------------------------------------------
## Step 5 -  1.) calculate the mean of each variable for each activity and each subject and 2.) write the table
## of means calculated in 1) to a text file.

data_mean <- ddply(data_all, .(Subject, Activity), function(data_all) colMeans(data_all[,3:81]))
write.table(data_mean, "data_mean.txt", row.name = FALSE)