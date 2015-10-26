Getting and Cleaning Data Course Project: Tidying Data from the Human Activity Recognition Using Smartphones Dataset
========================================


Steps
-----
The steps taken to tidy the data are in the source code 'run_analysis.R'. This code can be run in the directory containing the smart phone data. The steps are as follows:
 1. Train and test datasets were merged.
 2. Measurements on only the mean and standard deviation for each observation were extracted from the merged dataset.
 3. Activity names for the six activities (Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, Laying) were added to the merged dataset.
 4. Two of the variables in the merged dataset were given descriptive names (Subject and Activity).
 5. The mean of each variable for each activity and each of the 30 subjects was calculated and a new table of these means was written out to the file 'data_mean.txt'.

The table from step 5 above consists of 180 rows and 81 columns. The rows consists of the subject # and activity and the means of the measurements of 79 variables that were taken for that particular subject/activity pair.

The descriptors of the 79 variables for which the means were calculated are listed in CodeBook.md
