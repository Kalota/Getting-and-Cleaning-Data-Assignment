library(reshape2)
library(plyr)

#Reading the .txt files into R
XTest  <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=FALSE)
XTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=FALSE)

#Merging the XTest and XTrain dataset
Xdata  <- rbind(XTest,XTrain)

##Reading features to set columns names of the merged dataset
features  <- read.table("./data/UCI HAR Dataset/features.txt", header=FALSE)
colnames(Xdata) <- features$V2

#Reading activity IDs
YTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=FALSE)   
YTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=FALSE)

#Merging the activity IDs
activityIDs <- rbind(YTest,YTrain)

#Adding the activityIDs to the Xdata
Xdata$activityID <- activityIDs$V1


#Setting the Activity Labels
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", 
                             header=FALSE, col.names=c("ActivityID", "ActivityName"))
data  <-  merge(Xdata, activityLabels)

#Setting the subjects
subjectID1 <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header=FALSE)
subjectID2 <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header=FALSE)

#Merging the subject IDs
subjectID <- rbind(subjectID1, subjectID2)

#Adding the subjectID to the subdata
data$SubjectID  <-subjectID$V1

#Extracting only the mean and standard deviation of each measurement
mean_sd_data <-data[,c("SubjectID","ActivityID",mean_colnames,sd_colnames)]
descrnames <- merge(activity_labels,mean_sd_data,by.x="ActivityID",by.y="ActivityID",all=TRUE)
data_melt <- melt(descrnames,id=c("ActivityID","ActivityName","SubjectID"))
mean_data <- dcast(data_melt,ActivityID + ActivityName + SubjectID ~ variable,mean)

#Creating and reading out the tidy data
write.table(mean_data,"./tidydata.txt")
