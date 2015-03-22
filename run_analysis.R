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

