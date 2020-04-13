# Codebook

## run_analysis.R

### Downloading the data
```R
filename = "GCD_CP"

if(!file.exists(filename))
{
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, destfile = "GCD_CP", method="curl")
}

if(!file.exists("UCI HAR Dataset"))
{
    unzip(filename) 
}
```

The data is downloaded directly from the URL and unzipped in the working directory.

### Reading in the data

```R
features <-      read.table("UCI HAR Dataset/features.txt",            
                            col.names = c("n","functions"))
activities <-    read.table("UCI HAR Dataset/activity_labels.txt",     
                            col.names = c("code", "activity"))
subject_test <-  read.table("UCI HAR Dataset/test/subject_test.txt",   
...
```
The data is read in from each file to its own data frame.

### Step 1
> Merges the training and the test sets to create one data set.
```R
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
step1 <- cbind(Subject, Y, X)
```
* Use row-bind to connect tables for training and test sets for x, y and subject
* Use column-bind to connect tables for subject, y and x

### Step 2
> Extracts only the measurements on the mean and standard deviation for each measurement. 
```R
step2 <- select(step1, subject, code, contains("mean"), contains("std"))
```
Use select to form a new table from step1, choosing only columns subject, code and anything containing the patterns "mean" and "std".

### Step 3
> Uses descriptive activity names to name the activities in the data set
```R
step3 <- step2
step3$code <- activities[step2$code, 2] 
```
Take the activity names from the second column of the activities table and use them as descriptive column names in place of the activity code column.

### Step 4
> Appropriately labels the data set with descriptive variable names. 
```R
step4 <- step3
names(step4)[2] <- "activity"
names(step4) <- gsub(pattern="Acc",      replacement="Accelerometer", 
                     x=names(step4))
names(step4) <- gsub(pattern="Gyro",     replacement="Gyroscope",     
                     x=names(step4))
...
```
Search for patterns in the names of columns for the table, replace the patterns with more descriptive full names.

### Step 5
> From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```R
step5 <- step4
step5 <- step5[ , names(step5) != "subject"]
step5 <- summarise_all(group_by(step5, activity), mean)
write.table(step5, "meanResultsByActivity.txt", row.names = FALSE)
```
* Remove the subjects column, unnecessary when addressing mean values by column
* Take the mean of each column, grouped by the activity
* Write the table out to meanResultsByActivity.txt

## Variables and Data
The resulting dataset is a table of mean values for a series of measurements by the activity that was being performed while they were recorded.

The activities recorded inlcude...
1. Walking
2. Walking upstairs
3. Walking downstairs
4. Sitting
5. Standing
6. Laying
