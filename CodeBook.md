---
title: "Code Book for cleaning data class project"
author: "HCM"
date: "November 18, 2015"
output: pdf_document
---

This is a Code Book for Getting and Cleaning Data Course Project. 


#Download and summarize data#

Download data from 

<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

Looks like the measured features, or variables, are contained is the features.txt file, and the data are contained in the X-test and X-train files.


The required steps for the projects are:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

In practice, the steps were executed in a different order: 2,3,4,1,5.  My computer does not have enough memory and diskspace to handle large data sets and forze when merging the full data sets.  **Therefore, I first performed steps 2,3,4 to reduce the size of the data down to what is necessary for this project, then proceed with steps 1 and 5. The following describes each step.**

#Step 2 Extracts only the measurements on the mean and standard deviation for each measurement.#

The measured features, or variables, are contained is the *features.txt* file. Extract those that inlucde the word mean or std.  Here is the list of 79 variables that contain either "mean" or "std" that we want:

 [1] "tBodyAcc-mean()-X"              
 [2] "tBodyAcc-mean()-Y"              
 [3] "tBodyAcc-mean()-Z"              
 [4] "tBodyAcc-std()-X"               
 [5] "tBodyAcc-std()-Y"               
 [6] "tBodyAcc-std()-Z"               
 [7] "tGravityAcc-mean()-X"           
 [8] "tGravityAcc-mean()-Y"           
 [9] "tGravityAcc-mean()-Z"           
[10] "tGravityAcc-std()-X"            
[11] "tGravityAcc-std()-Y"            
[12] "tGravityAcc-std()-Z"            
[13] "tBodyAccJerk-mean()-X"          
[14] "tBodyAccJerk-mean()-Y"          
[15] "tBodyAccJerk-mean()-Z"          
[16] "tBodyAccJerk-std()-X"           
[17] "tBodyAccJerk-std()-Y"           
[18] "tBodyAccJerk-std()-Z"           
[19] "tBodyGyro-mean()-X"             
[20] "tBodyGyro-mean()-Y"             
[21] "tBodyGyro-mean()-Z"             
[22] "tBodyGyro-std()-X"              
[23] "tBodyGyro-std()-Y"              
[24] "tBodyGyro-std()-Z"              
[25] "tBodyGyroJerk-mean()-X"         
[26] "tBodyGyroJerk-mean()-Y"         
[27] "tBodyGyroJerk-mean()-Z"         
[28] "tBodyGyroJerk-std()-X"          
[29] "tBodyGyroJerk-std()-Y"          
[30] "tBodyGyroJerk-std()-Z"          
[31] "tBodyAccMag-mean()"             
[32] "tBodyAccMag-std()"              
[33] "tGravityAccMag-mean()"          
[34] "tGravityAccMag-std()"           
[35] "tBodyAccJerkMag-mean()"         
[36] "tBodyAccJerkMag-std()"          
[37] "tBodyGyroMag-mean()"            
[38] "tBodyGyroMag-std()"             
[39] "tBodyGyroJerkMag-mean()"        
[40] "tBodyGyroJerkMag-std()"         
[41] "fBodyAcc-mean()-X"              
[42] "fBodyAcc-mean()-Y"              
[43] "fBodyAcc-mean()-Z"              
[44] "fBodyAcc-std()-X"               
[45] "fBodyAcc-std()-Y"               
[46] "fBodyAcc-std()-Z"               
[47] "fBodyAcc-meanFreq()-X"          
[48] "fBodyAcc-meanFreq()-Y"          
[49] "fBodyAcc-meanFreq()-Z"          
[50] "fBodyAccJerk-mean()-X"          
[51] "fBodyAccJerk-mean()-Y"          
[52] "fBodyAccJerk-mean()-Z"          
[53] "fBodyAccJerk-std()-X"           
[54] "fBodyAccJerk-std()-Y"           
[55] "fBodyAccJerk-std()-Z"           
[56] "fBodyAccJerk-meanFreq()-X"      
[57] "fBodyAccJerk-meanFreq()-Y"      
[58] "fBodyAccJerk-meanFreq()-Z"      
[59] "fBodyGyro-mean()-X"             
[60] "fBodyGyro-mean()-Y"             
[61] "fBodyGyro-mean()-Z"             
[62] "fBodyGyro-std()-X"              
[63] "fBodyGyro-std()-Y"              
[64] "fBodyGyro-std()-Z"              
[65] "fBodyGyro-meanFreq()-X"         
[66] "fBodyGyro-meanFreq()-Y"         
[67] "fBodyGyro-meanFreq()-Z"         
[68] "fBodyAccMag-mean()"             
[69] "fBodyAccMag-std()"              
[70] "fBodyAccMag-meanFreq()"         
[71] "fBodyBodyAccJerkMag-mean()"     
[72] "fBodyBodyAccJerkMag-std()"      
[73] "fBodyBodyAccJerkMag-meanFreq()" 
[74] "fBodyBodyGyroMag-mean()"        
[75] "fBodyBodyGyroMag-std()"         
[76] "fBodyBodyGyroMag-meanFreq()"    
[77] "fBodyBodyGyroJerkMag-mean()"    
[78] "fBodyBodyGyroJerkMag-std()"     
[79] "fBodyBodyGyroJerkMag-meanFreq()"


And here is the list of 6 activities we need to include:

1. WALKING
2. WALKING_UPSTAIRS
3. WALKING_DOWNSTAIRS
4. SITTING
5. STANDING
6. LAYING


#Step 3 Uses descriptive activity names to name the activities in the data set#

1. Activity codes are contained in *y_test.txt* and *y_train.txt*. 
2. Activity names are in *activity_lables.txt*.
3. Read in the Activity names and assign them to each row that has the corresponding activity code.

#Step 4 Appropriately labels the data set with descriptive variable names# 

1. Add names from the list of variables obtained in step 2 above to the test and train data sets. 
2. Subset data to include only the columns that contain variables having to do with mean or std.
3. Add activity names and subject code to each subset data sets and form new data frame for test and training sets.

#Now we can do step 1: Merges the training and the test sets to create one data set#

#Now for step 5: Create a second, independent tidy data set with the average of each variable (there are 79 variables that contains mean and std), #for each activity (there are 6 activities) and each subject (there are 30 subjects)#

1. Filter by activity. This results in a list with 6 elements.
2. Filter by subject.  This generates a list with 30 subjects.  
3. For each subject, there are 50 measurements (more or less) for each variable. This genreates a 50 row x 79 column data frame for each subject.
4. Do a column mean for each variable. This produces a vector of length 79.
5. Organize a tidy data set by haivng the variables in columns and subjects in rows.  And given them appropriate names.
6. Write output data set as required.