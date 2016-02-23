## Getting and Cleaning Data Final Project 
## Clear Environment, clear memeory and load dependent packages

rm(list = ls())
gc()
library(dplyr)

## I downloaded and unzipped the contents of the file, moving only the files needed for this
## to the working directory. 

setwd(## I've removed the WD path because it contains information I do not want to share publically, but it would be here)
  
  ## Read in X, Y and subject test/train data
  X_Test = read.table("X_test.txt", header = FALSE)
  X_Train = read.table("X_train.txt", header = FALSE) 
  Y_Test = read.table("y_test.txt", header = FALSE)
  Y_Train = read.table("y_train.txt", header = FALSE)
  Sub_Test = read.table("subject_test.txt", header = FALSE)
  Sub_Train = read.table("subject_train.txt", header = FALSE)
  
  ## Read in Activity labels
  activity_labels = read.table("activity_labels.txt")
  activity_labels = activity_labels[,-1] 
  
  
  ## Bind test and train data sets 
  X_Bind = rbind(X_Test,X_Train)
  Y_Bind = rbind(Y_Train, Y_Test)
  Sub_Bind  = rbind(Sub_Test, Sub_Train)
  
  ## relabel all variables with descriptive names = Tidy Data. 
  names(Sub_Bind) = "Subject"
  names(Y_Bind) = "Activity"
  
  ## Update column names to appropriate variable names 
  ActivityNames = read.table("features.txt", head = FALSE)
  names(X_Bind) = ActivityNames$V2 
  
  ## Bring all data together
  Combined_Data = cbind(Sub_Bind, Y_Bind)
  FCombined_Data = cbind(X_Bind, Combined_Data)
  
  ## Pull std() and mean() formula variables
  Form_Pull = X_Bind$V2[grep("mean\\(\\) | std\\(\\)", X_Bind$V2)]
  
  ## ID Subject and Activity variables that match above criteria
  Sub_Act = c(as.character(Form_Pull), "Subject", "Activity")
  
  ## Subset Data table using only Subject and Activity (Above). 
  FCombined_Data = subset(FCombined_Data, select = Sub_Act)
  
  ## write in activities labels from activities text file
  activities = read.table("activity_labels.txt", header = FALSE)
  
  ## Update Activity factors from numerical to labels, i.e. take 2nd column of Data and redefine as
  ## second column of ActivityNames = Tidy Data Set 
  
  FCombined_Data$Activity[FCombined_Data$Activity == 1] <- "WALKING"
  FCombined_Data$Activity[FCombined_Data$Activity == 2] <- "WALKING_UPSTAIRS"
  FCombined_Data$Activity[FCombined_Data$Activity == 3] <- "WALKING_DOWNSTAIRS"
  FCombined_Data$Activity[FCombined_Data$Activity == 4] <- "SITTING"
  FCombined_Data$Activity[FCombined_Data$Activity == 5] <- "STANDING"
  FCombined_Data$Activity[FCombined_Data$Activity == 6] <- "LAYING"
  
  ## Bring all Data togther 
  FCombined_Data = cbind(X_Bind, FCombined_Data)
  
  ## Bring final data set together and calculate mean/average across all rows for each Subject & Activity
  Final_Data = aggregate(. ~ Subject + Activity, FCombined_Data, mean)
  
  ## Arrange final data set by Subject and Activity 
  Final_Data = arrange(Final_Data,Subject, Activity)
  
  ## write the .txt file w/ row.names = FALSE per instructions...
  write.table(Final_Data, "GCD.txt", row.names = FALSE)
  