library(dplyr)

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

features <-      read.table("UCI HAR Dataset/features.txt",            
                            col.names = c("n","functions"))
activities <-    read.table("UCI HAR Dataset/activity_labels.txt",     
                            col.names = c("code", "activity"))
subject_test <-  read.table("UCI HAR Dataset/test/subject_test.txt",   
                            col.names = "subject")
x_test <-        read.table("UCI HAR Dataset/test/X_test.txt",         
                            col.names = features$functions)
y_test <-        read.table("UCI HAR Dataset/test/y_test.txt",         
                            col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject")
x_train <-       read.table("UCI HAR Dataset/train/X_train.txt",       
                            col.names = features$functions)
y_train <-       read.table("UCI HAR Dataset/train/y_train.txt",       
                            col.names = "code")

#STEP 1
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
step1 <- cbind(Subject, Y, X)

#STEP 2
step2 <- select(step1, subject, code, contains("mean"), contains("std"))

#STEP 3
step3 <- step2
step3$code <- activities[step2$code, 2] 

#STEP 4
step4 <- step3
names(step4)[2] <- "activity"
names(step4) <- gsub(pattern="Acc",      replacement="Accelerometer", 
                     x=names(step4))
names(step4) <- gsub(pattern="Gyro",     replacement="Gyroscope",     
                     x=names(step4))
names(step4) <- gsub(pattern="BodyBody", replacement="Body",          
                     x=names(step4))
names(step4) <- gsub(pattern="Mag",      replacement="Magnitude",     
                     x=names(step4))
names(step4) <- gsub(pattern="^t",       replacement="Time",          
                     x=names(step4))
names(step4) <- gsub(pattern="^f",       replacement="Frequency",     
                     x=names(step4))
names(step4) <- gsub(pattern="tBody",    replacement="TimeBody",      
                     x=names(step4))
names(step4) <- gsub(pattern="-mean()",  replacement="Mean",          
                     x=names(step4), ignore.case = TRUE)
names(step4) <- gsub(pattern="-std()",   replacement="STD",           
                     x=names(step4), ignore.case = TRUE)
names(step4) <- gsub(pattern="-freq()",  replacement="Frequency",     
                     x=names(step4), ignore.case = TRUE)
names(step4) <- gsub(pattern="angle",    replacement="Angle",         
                     x=names(step4))
names(step4) <- gsub(pattern="gravity",  replacement="Gravity",       
                     x=names(step4))

#STEP 5
step5 <- step4
step5 <- step5[ , names(step5) != "subject"]
step5 <- summarise_all(group_by(step5, activity), mean)
write.table(step5, "meanResultsByActivity.txt", row.names = FALSE)

