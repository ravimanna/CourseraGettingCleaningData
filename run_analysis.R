library(reshape2)

# Download the dataset to working directory
file <- file.path(getwd(), "FUCIDataset.zip")

if (!file.exists(file)) {
        
        download.file('https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip',
                      destfile='FUCIDataset.zip', mode="wb")
        unzip('FUCIDataset.zip')
}

# Get activity labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]

# Get features
features <- read.table("UCI HAR Dataset/features.txt")[,2]
#meanstdFeatures <- grepl(".*Mean().*|.*Std().*", features)
meanstdFeatures <- grep("mean\\(|std\\(", features)

##################### Training Data ###############################
# Load data
trainingSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainingX <- read.table("UCI HAR Dataset/train/X_train.txt")
trainingY <- read.table("UCI HAR Dataset/train/Y_train.txt")

# Add column header
colnames(trainingSubject) <- "Subject"
colnames(trainingX) <- features
colnames(trainingY) <- "Activity"

# Subset Mean and Std 
trainingX <- trainingX[ , meanstdFeatures]

# Merge columns
trainingData <- cbind(trainingSubject, trainingY, trainingX)

############################# Test Data ###############################
# Load data
testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("UCI HAR Dataset/test/X_test.txt")
testY <- read.table("UCI HAR Dataset/test/Y_test.txt")

# Add column headers
colnames(testSubject) <- "Subject"
colnames(testX) <- features
colnames(testY) <- "Activity"

# Subset mean std features
testX <- testX[ , meanstdFeatures]

# Merge columns
testData <- cbind(testSubject, testY, testX)

########################################################################

# Merge training and test data
allData <- rbind(trainingData, testData)

# summarize the means by activity-subject
data2melt <- melt(allData, id=c("Subject", "Activity"))
tidyData <- dcast(data2melt, Activity + Subject ~ variable, mean)

# Label activities
tidyData$Activity <- factor(tidyData$Activity, labels=activityLabels)

# Write to file
write.table(tidyData, file="./tidyData.txt", sep="\t", row.names=FALSE)


