## Create one R script called run_analysis.R that does the following. 

## -------Get the data from the source and unzip the package--------

        if(!file.exists("./Data")){dir.create("./Data")}
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        file<-"./Data/Dataset.zip"
        download.file(fileUrl,file,method="curl")
        unzip(zipfile=file,exdir="./Data")
        path<- file.path("./Data" , "UCI HAR Dataset")


### 1. Merges the training and the test sets to create one data set.

# Merge features data
        dataFeaturesTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)
        dataFeaturesTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
        dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)
        dataFeaturesNames <- read.table(file.path(path, "features.txt"),head=FALSE)

        names(dataFeatures)<- dataFeaturesNames$V2

# Merge subject data
        dataSubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
        dataSubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)
        dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
        names(dataSubject)<-c("subject")

# Merge activity data
        dataActivityTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
        dataActivityTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
        dataActivity<- rbind(dataActivityTrain, dataActivityTest)
        names(dataActivity)<- c("activity")


#Merge suject & activity

        dataMerge<-cbind(dataSubject, dataActivity)

#Combined data set

        CombinedDataSet<-cbind(dataFeatures, dataMerge)
str(CombinedDataSet)

### 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# take only Names of Features with "mean()" or "std()"
        subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

# subset only the data for the above
        selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
        Data<-subset(CombinedDataSet,select=selectedNames)


### 3. Uses descriptive activity names to name the activities in the data set

        activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)


### 4. Appropriately labels the data set with descriptive variable names. 

        names(Data)<-gsub("Acc", "Accelerometer", names(Data))
        names(Data)<-gsub("BodyBody", "Body", names(Data))
        names(Data)<-gsub("Mag", "Magnitude", names(Data))
        names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
        names(Data)<-gsub("^t", "time", names(Data))
        names(Data)<-gsub("^f", "frequency", names(Data))

### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Load the dplyrlibraries...
        library(plyr);

        Data2<-aggregate(. ~subject + activity, Data, mean)
        Data2<-Data2[order(Data2$subject,Data2$activity),]
        write.table(Data2, file = "./Data/tidydata.txt",row.name=FALSE)





