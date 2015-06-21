install.packages("plyr")
library(plyr)

#1-Merges the training and the test sets to create one data set.
TestSubject<-read.table("test/subject_test.txt")
TestX<-read.table("test/X_test.txt")
TestY<-read.table("test/y_test.txt")

TrainSubject<-read.table("train/subject_train.txt")
TrainX<-read.table("train/X_train.txt")
TrainY<-read.table("train/y_train.txt")

DataSubject<-rbind(TestSubject,TrainSubject)
DataX<-rbind(TestX,TrainX)
DataY<-rbind(TestY,TrainY)

#2-Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("./features.txt")
featuresIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
DataX<-DataX[,featuresIndices]

#3-Uses descriptive activity names to name the activities in the data set
names(DataY)<-"Activity"
names(DataSubject)<-"Subject"
names(DataX)<-features[featuresIndices,2]

DataSet<-cbind(DataSubject,DataY,DataX)
DataSet[,2]<-gsub(1, "Walking", DataSet[,2])
DataSet[,2]<-gsub(2, "Walking Upstairs", DataSet[,2])
DataSet[,2]<-gsub(3, "Walking Downstairs", DataSet[,2])
DataSet[,2]<-gsub(4, "Sitting", DataSet[,2])
DataSet[,2]<-gsub(5, "Standing", DataSet[,2])
DataSet[,2]<-gsub(6, "Laying", DataSet[,2])

#4-Appropriately labels the data set with descriptive variable names.

names(DataX)<-features[featuresIndices,2]

#5-From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

DataAverage <- ddply(DataSet, .(Subject, Activity), function(x) colMeans(x[, 3:68]))
write.table(DataAverage, "DataAverage.txt", row.name=FALSE)
