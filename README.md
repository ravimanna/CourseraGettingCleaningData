##### This repo contains the following files,

1. The run_analysis.R script file that processes and prepares tidy data set from Human Activity Recognition data set.
2. The CodeBook.md file explains the tidy output dataset
3. The tidyData.txt file that contains the data set in text format with no row numbers

##### How to run the project
Download the initial data sets from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

Complete details of the initial data set can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

Extract the downloaded zip file into the working directory

Place "run_analysis.R"" script in your working directory and use the command source("run_analysis.R") to execute the script.

##### Below is how the script works
Download the data set from the url 
```
file <- file.path(getwd(), "FUCIDataset.zip")

if (!file.exists(file)) {        
    download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                  destfile='FUCIDataset.zip', 
                  mode="wb")
    unzip('FUCIDataset.zip')
}
```
Get activities and features (only mean & standard deviation) names
```
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("UCI HAR Dataset/features.txt")[,2]
meanstdFeatures <- grepl(".*Mean.*|.*Std.*", features)
```
Manage Training datadata
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
Manage Test data
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
Merge Training & Test data
```
allData <- rbind(trainingData, testData)
```

Summarize the data by Activity & Subject 
```
data2melt <- melt(allData, id=c("Subject", "Activity"))
tidyData <- dcast(data2melt, Activity + Subject ~ variable, mean)

tidyData$Activity <- factor(tidyData$Activity, labels=activityLabels)
```
Output the tidy data to a file
```
write.table(tidyData, file="./tidyData.txt", sep="\t", row.names=FALSE)
```
