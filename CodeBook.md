## Peer Assessment CodeBook

The source data is downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip). 

The description of the source data is available [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The purpose of this project is to,

#####Download the data set from the url 
```
file <- file.path(getwd(), "FUCIDataset.zip")

if (!file.exists(file)) {        
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                  destfile='FUCIDataset.zip', 
                  mode="wb")
    unzip('FUCIDataset.zip')
}
```
#####Get activities and features (only mean & standard deviation) names
```
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("UCI HAR Dataset/features.txt")[,2]
meanstdFeatures <- grepl(".*Mean.*|.*Std.*", features)
```
#####Manage Training datadata
```
trainingSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainingX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingY <- read.table("UCI HAR Dataset/train/Y_train.txt")

colnames(trainingSubject) <- "Subject"
colnames(trainingX) <- features
colnames(trainingY) <- "Activity"

trainingX <- trainingX[ , meanstdFeatures]

trainingData <- cbind(trainingSubject, trainingY, trainingX)
```
#####Manage Test data
```
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/Y_test.txt")

colnames(testSubject) <- "Subject"
colnames(testX) <- features
colnames(testY) <- "Activity"

testX <- testX[ , meanstdFeatures]

testData <- cbind(testSubject, testY, testX)
```
#####Merge Training & Test data
```
allData <- rbind(trainingData, testData)
```

#####Summarize the data by Activity & Subject 
```
data2melt <- melt(allData, id=c("Subject", "Activity"))
tidyData <- dcast(data2melt, Activity + Subject ~ variable, mean)

tidyData$Activity <- factor(tidyData$Activity, labels=activityLabels)
```
#####Output the tidy data to a file
```
write.table(tidyData, file="./tidyData.txt", sep="\t", row.names=FALSE)
```


