library(plyr)
library(reshape2)

#Preliminary steps ; download dataset, unzips, reads datasest 

file_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(file_url, destfile="Dataset.zip", method ="curl")
unzip("Dataset.zip")
setwd('UCI HAR Dataset/')

date_downloaded <- date()

# Read raw data from training dataset
train_dataset <- read.table("./train/X_train.txt")
train_label <- read.table("./train/y_train.txt")
train_subject <- read.table("./train/subject_train.txt")

# Read raw data from test dataset 
test_dataset <- read.table("./test/X_test.txt")
test_label <- read.table("./test/y_test.txt") 
test_subject <- read.table("./test/subject_test.txt")

# Step1 : Merges the training and the test sets to create one data set 
train_all  <- cbind(train_dataset, train_label, train_subject)
test_all <- cbind(test_dataset,test_label, test_subject )

merged_data <- rbind(train_all, test_all)

# Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement  & # Step 4: Appropriately labels the data set with descriptive variable names 


# Better labels
features = read.table("features.txt", sep="", header=FALSE)

features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

mean_std_in_features <- grep(".*Mean.*|.*Std.*", features[,2])

features_less <- features[mean_std_in_features,]
mean_std_in_features <- c(mean_std_in_features, 562, 563)
mean_std_merged <- merged_data[,mean_std_in_features]
colnames(mean_std_merged) <- c(features_less$V2, "Activity", "Subject")

# Step 3 : Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt")
mean_std_merged$Activity <- factor(mean_std_merged$Activity, levels=activity_labels$V1, labels=activity_labels$V2)

write.table(as.data.frame(mean_std_merged), file="tidy.txt", sep="\t", quote=F, row.name=FALSE)

