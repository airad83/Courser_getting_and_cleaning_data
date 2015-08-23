library(plyr)

#Preliminary steps ; download dataset, unzips, reads datasest 

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(file_url, destfile="Dataset.zip", method ="curl")
unzip("Dataset.zip")
setwd('UCI HAR Dataset/')

date_downloaded <- date()

# Read raw data from training dataset
train_dataset <- read.table("./train/X_train.txt")
train_dataset <- read.table("./train/y_train.txt")
train_dataset <- read.table("./train/subject_train.txt")

# Read raw data from test dataset 
test_dataset <- read.table("./test/X_test.txt")
test_label <- read.table("./test/y_test.txt") 
test_subject <- read.table("./test/subject_test.txt")

# Step1 : Merges the training and the test sets to create one data set
train_all  <- cbind(train_dataset, train_dataset, train_dataset)
test_all <- cbind(test_dataset,test_label, test_subject )

merged_data <- rbind(train_all, test_all)

# Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement

features = read.table("features.txt", sep="", header=FALSE)

features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])


# Step 3: Uses descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
train_and_test_label[, 1] <- activities[train_and_test_label[, 1], 2]
names(train_and_test_label) <- "activity"

# Step 4: Appropriately labels the data set with descriptive variable names. 

# Step5:  From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.