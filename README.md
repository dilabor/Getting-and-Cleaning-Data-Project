This repo was created to fulfill the requirements for the main project in the course: Getting and Cleaning Data

The goal and the requirements for the project are:
--------------------------------------------------

The purpose of this project is to demonstrate the ability to collect, work with, and clean a data set. The goal 
is to prepare tidy data that can be used for later analysis. 

It is required to submit:   
1) a tidy data set as described below,   
2) a link to this Github repository with the script for performing the analysis, and   
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean 
up the data called CodeBook.md. Also to be included is a README.md in the repo with all scripts. 


The effort should create one R script called run_analysis.R that does the following: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for 
   each activity and each subject.

Project notes and assumptions:
-----------------------------

The associated code book contains all the details about the original data set and what was done to create a subset 
of that data adhering to Tidy Data standards.

Below is a copy of the script "run_analysis.R" which accomplishes all the data transformations and manipulations
required for the project.

Note that the script begins with the assumption tha the data set has been downloaded and unziped in a directory 
called 'data' that resides in the working directory.  Otherwise the script is standalone and can be run as needed.

The location of the data set downloaded is described in the code book.

The comments contained in the scrip are relatively detailed and explain what is happening at each key juncture in the
script itself.

Following is the R script used:
------------------------------

run_analysis.R:

## Getting and Cleaning Data - Course Project
##
##  Start of script - run_analysis.R
##
## libraries used in script
##
library(reshape2)
##
##  Data set resides in "data' directory in working directory
##
##  Reading training and test measurement data from appropriate files
##
x_train <- read.table("./data/train/x_train.txt", header=F)
y_train <- read.table("./data/train/y_train.txt", header=F)
subject_train <- read.table("./data/train/subject_train.txt", header=F)
training <- cbind(cbind(x_train,y_train), subject_train)
x_test <- read.table("./data/test/x_test.txt", header=F)
y_test <- read.table("./data/test/y_test.txt", header=F)
subject_test <- read.table("./data/test/subject_test.txt", header=F)
##
##  Reading ID variable data associated with measurement data
##
features <- read.table("./data/features.txt", header=F)
activity_labels <- read.table("./data/activity_labels.txt", header=F)
##
## (#1) Merge training and test sets into one data set
##
train_data <- cbind(cbind(x_train,y_train), subject_train)
test_data <- cbind(cbind(x_test,y_test), subject_test)
data_set <- rbind(train_data, test_data)
##
## As missing data would be unexpected the script checks and would stop if any was identified.
##
if (!(all(colSums(is.na(data_set))==0))) stop('missing data - please check')
##
## (#3) Label the data set with given variable names adding Activity and Subject ID
##
names(data_set) = features[,2]
names(data_set)[562] = "Activity"
names(data_set)[563] = "Subject_ID"
##
## Update activity ID with descriptive name using activity_labels
##
data_set$Activity <- activity_labels[data_set$Activity,2]
##
## (#2) Subset data with mean and standard deviation measurements based on "mean()" and "std()" 
##      identify correct rows as data set features.info.txt documentation states
##
data_set <- data_set[, grepl("mean\\(\\)|std\\(\\)|subject|activity", names(data_set), ignore.case = T)]
##
## (#4) Improve readability of variable names by making them more descriptive as part of Tidy Data process
##
tidy.variable.names <- names(data_set)
tidy.variable.names <- gsub("Acc", "Accelerometer", tidy.variable.names)
tidy.variable.names <- gsub("Gyro", "Gyroscope", tidy.variable.names)
tidy.variable.names <- gsub("Mag", "Magnitude", tidy.variable.names)
tidy.variable.names <- gsub("Freq", "Frequency", tidy.variable.names)
tidy.variable.names <- gsub("^t", "Time", tidy.variable.names)
tidy.variable.names <- gsub("^f", "Frequency", tidy.variable.names)
tidy.variable.names <- gsub("std", "StandardDeviation", tidy.variable.names)
tidy.variable.names <- gsub("mean", "Mean", tidy.variable.names)
tidy.variable.names <- gsub("()-", "Direction", tidy.variable.names)
names(data_set) <- tidy.variable.names
##
## (#5) Create second independant tidy data set with average for each variable for each 
## activity and each subject. Result is in wide format.
##
grouped_data <- melt(data_set, id=c("Subject_ID", "Activity"))
tidy_data_set <- dcast(grouped_data, Subject_ID+Activity~variable, mean)
##
## Write second independent tidy data set to txt file without row names
##
write.table(tidy_data_set, file = "tidy_data_set.txt", row.names = F)
##
## End of script - run_analysys.R
##

