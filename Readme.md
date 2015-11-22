---
title: "Readme for run_analysis.R"
author: "Stephen Reader"
date: "November 20, 2015"
---

run_analysis.R contains a script that reads in data from the "UCI HAR Dataset" folder stored in your working directory, and creates a tidy data set stored in the "tidydata" variable. Each of the 180 rows in "tidydata" is an observation of an activity performed by a subject across 66 variables. Each variable is the average of either the mean or standard deviation of particular data collected on the subject's movement while performing an activity.

Background
==========
The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. A training set and a test set were merged to create the "tidydata" set.

*For more detail on experimental design and contents of the "UCI HAR Dataset" folder, consult original README.txt within that folder

Features
========
"tidydata" contains only averages of the mean and standard deviations of measurements taken by the accelerometer and gyroscope. A total of 561 variables were included in the original data for both training and test sets, but only 66 of those dealt specifically with the mean or standard deviation of a particular measurement.

*For more detail on the variables in "tidydata", consult Codebook.md in the GitHub repo. For more detail on the raw measurements manipulated for "tidydata", consult fetures.txt and features_info.txt in the "UCI HAR Dataset" folder

run_analysis script function
============================
With the "UCI HAR Dataset" folder and all subfolders in your working directory, run_analysis performs the following steps:

1. Loads the data.table and reshape2 libraries
2. Reads in the features.txt and activity_labels.txt files as data frames (accounting for possible NAs) and stores them in variables. Names columns in activity_labels "Index" and "Activity" for merging purposes later.
3. Reads in the training data set (x_train, y_train, subject_train) and test data set (x_test, y_test, subject_test), each as a data frame (accounting for possible NAs) and each stored in its own variable.
4. Names columns in x_train and x_test data frames using the second column of the features data frame.
5. Names the column in y_train and y_test "Index" and the column in subject_train and subject_trest "Subject" for merging purposes later.
6. Creates traintest data frame from binding rows in x_train and x_test.
7. Creates activities data frame from binding rows in y_train and y_test.
8. Creates subjects data frame from binding rows in subject_train and subject_test.
9. Subsets the traintest data so it only includes columns that are either mean or standard deviation measurements.
10. Creates mergedData data frame that binds the subjects (col named "Subject") and activities (col named "Index") data frames to the left of the traintest columns.
11. Adds a column to the right of mergedData containing the activity name from activity_labels (col named "Activity") that corresponds to the "Index" value for each observation.
12. Replaces the "Index" (col 2) with the newly added "Activity" column, replacing indexing integer with the name of the activity performed by the subject.
13. Stores names of mergedData variable columns to use in melt function later.
14. Melts mergedData with "Subject" and "Activity" as IDs and columns stored in previous step as measured variables
15. Creates tidydata variable with dcast, specifying "Subject" and "Activity" pairs as rows and measured variables as columns, applying the mean() function to each of those columns.