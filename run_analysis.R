# loading required packages
library(tidyverse)

#loading the datasets form UCI HAR Dataset file.

features <- read.table("./data/UCI HAR Dataset/features.txt" , col.names = c("n","features"))
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt", col.names = features$features)
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt" , col.names = features$features)
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt" , col.names = "code")


#merging data inro one dataset

X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
Subject <- rbind(subject_train,subject_test)
Data <- cbind(Subject,Y,X)




#Extracting only measurments on the mean and standard deviation.

#dplyr :: select instead of select because select was masked by MASS

TidyData <-Data %>% 
  dplyr :: select(subject, code, contains("mean"), contains("std"))


#Using descriptive names to name the activites

TidyData$code <- activities[TidyData$code, 2]


#Appropriately labels all variables with descriptive names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


#final independent dataset

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
