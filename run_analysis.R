##Loading dplyr library
library(dplyr)
activity_labels <- read.table("./Data/UCI HAR Dataset/activity_labels.txt")
features <- read.table("./Data/UCI HAR Dataset/features.txt")
## Loading train data
X_train <-read.table("./Data/UCI HAR Dataset/train/X_train.txt")
Y_train <-read.table("./Data/UCI HAR Dataset/train/Y_train.txt")
subject_train <-read.table("./Data/UCI HAR Dataset/train/subject_train.txt")
      
## Loading train data
X_test <-read.table("./Data/UCI HAR Dataset/test/X_test.txt")
Y_test <-read.table("./Data/UCI HAR Dataset/test/Y_test.txt")
subject_test <-read.table("./Data/UCI HAR Dataset/test/subject_test.txt")

## Merging the data
## since the data is divided on records basis, rbind is used for merging
X_merged <- rbind(X_train,X_test)
Y_merged <- rbind(Y_train,Y_test)
subject_merged <- rbind(subject_train,subject_test)

#Extracing measurements on the mean and standard deviation for each measurement
select_features <- features[grep("mean\\(\\)|std\\(\\)", features[,2]),]

#Keeping only the selcted features in our DataSet
X_merged <- X_merged[,select_features[,1]]

#Appropriately naming and organizing data
## For Y direction
colnames(Y_merged) <- "activity"
## Giving labels to activities in Y_merged from the All activity labels (Column is added)
Y_merged$activity_label <- factor(Y_merged$activity, labels = as.character(activity_labels[,2]))
## View the data
head(Y_merged$activity_label)
activity_labels <- Y_merged$activity_label
## X direction
colnames(X_merged) <- features[select_features[,1],2]

## Subject
colnames(subject_merged) <- "subject"

## creating a second, independent tidy data set with the average of each variable for each activity and each subject.
final_DataSet <- cbind(X_merged, activity_labels, subject_merged)
tidyData <- final_DataSet %>% group_by(activity_labels, subject) %>% summarize_each(funs(mean))
tidyData
# Writing final output of tidy data
write.table(tidyData, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)
