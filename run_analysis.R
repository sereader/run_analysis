library(data.table)
library(reshape2)

##read in features
features <- as.data.frame(fread("UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))

##read in and name activity labels
activity_labels <- as.data.frame(fread("UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))
names(activity_labels) <- c("Index", "Activity")

##read in train
x_train <- as.data.frame(fread("UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))
x_train <- x_train[complete.cases(x_train),]
y_train <- as.data.frame(fread("UCI HAR Dataset/train/Y_train.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))
subject_train <- as.data.frame(fread("UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))

##read in test
x_test <- as.data.frame(fread("UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))
x_test <- x_test[complete.cases(x_test),]
y_test <- as.data.frame(fread("UCI HAR Dataset/test/Y_test.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))
subject_test <- as.data.frame(fread("UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE, na.strings=c("NA","N/A","")))

##name training sets
names(x_train) <- features$V2
names(y_train) <- "Index"
names(subject_train) <- "Subject"

##name test sets
names(x_test) <- features$V2
names(y_test) <- "Index"
names(subject_test) <- "Subject"

traintest <- rbind(x_train, x_test)
activities <- rbind(y_train, y_test)
subjects <- rbind(subject_train, subject_test)

##subset mean and std cols in merged data frame
meanCols <- grepl("mean()", names(traintest), fixed=TRUE)
stdCols <- grepl("std()", names(traintest), fixed=TRUE)
columns <- meanCols == TRUE | stdCols == TRUE
traintest <- traintest[ , columns]

##add subjects and activities columns
mergedData <- cbind(subjects, activities, traintest)

##add activity names and replace integer column with the names
mergedData <- merge(mergedData, activity_labels, by.x="Index", by.y="Index")
col_idx <- grep("Activity", fixed = TRUE, names(mergedData))
halt <- ncol(mergedData) - 1
mergedData <- mergedData[, c(2, col_idx, (3:halt))]

##melt and dcast mergedData to return mean of each column by Subject and Activity
toAve <- names(mergedData[,3:ncol(mergedData)])
mergedMelt <- melt(mergedData, id=c("Subject", "Activity"), measure.vars=toAve)
tidydata <- dcast(mergedMelt, Subject + Activity ~ variable, mean)