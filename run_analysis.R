#my script for performing getting and cleaning data cource project

if(!file.exists("./data")){dir.create("./data")}
fileUrl="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
#download.file(fileUrl,destfile="./data/project.zip",method="curl") #method="curl" gives error messages
#download.file(fileUrl,destfile="./data/project.zip") #that downloaded the zip file but could not be opened
download.file(fileUrl,destfile="./data/project.zip",mode="wb") #same trick as .jpg file download, works.

fn<-"./data/project.zip"
a<-unzip(fn) #this gives a list of the file names contained the zip file, now extracted
length(a) #number of files total
a
#looks like the measured features, or variables, are contained is the features.txt file
list_var<-read.table(a[2])
head(list_var)
length(list_var$V1) #find out how many variables are there
#looks like the meat of the data are contained in the X-test and X-train files
grep("X_test",a)
grep("X_train",a)
a_test<-read.table(a[15])
a_train<-read.table(a[27])
dim(a_test)
#[1] 2947  561
dim(a_train)
#[1] 7352  561



# This is step 1 "Merges the training and the test sets to create one data set."
#merge two data sets
#a_all<-merge(a_test,a_train)  #this crashed R. Should extract mean and std first, since they are the only ones needed
#assign nature names to the column headings of the data files

library(dplyr)

#this is step 2 "Extracts only the measurements on the mean and standard deviation for each measurement. "

#grep multiple patterns
mean_std<-c("mean","std")
#infuriating:
#> right<-paste(mean_std,collapse="|")
#> wrong<-paste(mean_std,collaspe="|")
#> right
#[1] "mean|std"
#> wrong
#[1] "mean |" "std |" 


var_mean_std<-unique(grep(paste(mean_std,collapse="|"),list_var$V2,value=TRUE))
length(var_mean_std)

#this is step 3 "Uses descriptive activity names to name the activities in the data set"
#activity codes are contained in y_test.txt and y_train.txt
test_activity_code<-read.table(a[16])
train_activity_code<-read.table(a[28])
#might as well read subject codes now
test_subject_code<-read.table(a[14])
names(test_subject_code)<-"Subject_number"
train_subject_code<-read.table(a[26])
names(train_subject_code)<-"Subject_number"

#Activity names, assigned to each row
activity_name<-read.table(a[1])
test_activity_name<-activity_name[test_activity_code[,1],2]
train_activity_name<-activity_name[train_activity_code[,1],2]


#this is step 4 Appropriately labels the data set with descriptive variable names. 
names(a_test)<-list_var$V2
names(a_train)<-list_var$V2


#select only columns that contain mean or std
a_test_ms<-subset(a_test,select=var_mean_std)
a_train_ms<-subset(a_train,select=var_mean_std)

#add activity names and subject code to each:
a_test_ms_acti_subj<-data.frame(a_test_ms,test_activity_name,test_subject_code)
a_train_ms_acti_subj<-data.frame(a_train_ms,train_activity_name,train_subject_code)

#change to a common column name to avoid "NA"s after merging
names(a_test_ms_acti_subj)[80]<-"Activity_name"
names(a_train_ms_acti_subj)[80]<-"Activity_name"


#This is step 1 "
#now merge the data "Merges the training and the test sets to create one data set."

a_all<-merge(a_test_ms_acti_subj,a_train_ms_acti_subj,all=T) #need to have "all=T" to work

#Now for step 5: Create a second, independent tidy data set with 
#the average of each variable (there are 79 variables that contains mean and std)
#for each activity (there are 6 activities)
#and each subject (there are 30 subjects)

nSubj<-length(levels(as.factor(a_all$Subject_number))) # there are 30
nActi<-length(levels(as.factor(a_all$Activity_name))) #there should be 6

#filter by activity
#filter by subject
temp<-filter(a_all,Subject_number==1)
colMeans(temp[,1:79])

#a_by_act<-filter(a_all,Activity_name==Activity_name) #this keeps all activities
#dim(a_by_act)
#[1] 10299    81
bysub.mean<-list()
tidy.mean<-list()
a.byact.bysub.mean<-list()
for (i in 1:length(activity_name$V2)){
  a.byact<-filter(a_all,Activity_name==Activity_name[i]) #this keeps activity i
  dim(a.byact)
  #[1] 1944   81
  for (j in 1:30){
    a.byact.bysub<-filter(a.byact,Subject_number==j) #this keeps subject j
    dim(a.byact.bysub)  #looks like for activity 1 subject 1 was measured 50 times for each var. This is the mean we need.
    #[1] 50 81  
    a.byact.bysub.mean[[j]]<-colMeans(select(a.byact.bysub,-(Activity_name:Subject_number)))#for each j, it gives a vector of length 79, contains the mean of each of the 79 variables 
    
  }
  bysub.mean[[i]]<-data.frame(a.byact.bysub.mean)
  names(bysub.mean[[i]])<-c(1:30)
  tidy.mean[[i]]<-t(data.frame(a.byact.bysub.mean)) #transpose, put variable in col, subj by row
  names(tidy.mean[[i]])<-c(rep(var_mean_std,30)) #assign var name to each column
  row.names(tidy.mean[[i]])<-c(1:30)
}

names(tidy.mean)<-activity_name$V2  #there are 6 items on the list, each is assigned the name of the activity
write.table(tidy.mean,file="tidy_output.txt",row.name=F)  #this writes out 30 rows x 474 columns of data, the columns are 79 variables for each of the 6 activityes (6x79=474)
