library(dplyr)

# define path in "path" variable
path <- file.path("E:/abhay/course/Data Science-foundation with R/Getting and Cleaning Data/Week_4/getdata_projectfiles_UCI HAR Dataset","UCI HAR Dataset")

# read train data
X_train <- read.table(file.path(path,"train","X_train.txt"),header = FALSE)
y_train <- read.table(file.path(path,"train","y_train.txt"),header = FALSE)
subject_train <- read.table(file.path(path,"train","subject_train.txt"),header = FALSE)

# read test data
X_test <- read.table(file.path(path,"test","X_test.txt"),header = FALSE)
y_test <- read.table(file.path(path,"test","y_test.txt"),header = FALSE)
subject_test <- read.table(file.path(path,"test","subject_test.txt"),header = FALSE)

# read features of data
features <- read.table(file.path(path,"features.txt"),header = FALSE)

# read activity labels of data
activity_labels <- read.table(file.path(path,"activity_labels.txt"),header = FALSE)

# Merges the training and the test sets to create one data set
merge_X <- rbind(X_train,X_test)
merge_y <- rbind(y_train,y_test)
merge_subject <- rbind(subject_train,subject_test)

# Extracts only the measurements on the mean and standard deviation for each measurement
select_features <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
merge_X <- merge_X[,select_features[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(merge_y) <- "Activity_name"
merge_y$activitylabels <- factor(merge_y$Activity_name, labels = as.character(activity_labels[,2]))
activitylabels <- merge_y[,-1]
colnames(merge_subject) <- "Subject_name"

# Appropriately labels the data set with descriptive variable names
colnames(merge_X) <- features[select_features[,1],2]

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
AllInOne <- cbind(merge_X,activitylabels,merge_subject)
AllInOne_mean <- AllInOne %>% group_by(activitylabels,Subject_name) %>% summarize_each(funs(mean))
write.table(AllInOne_mean,file <- "E:/abhay/course/Data Science-foundation with R/Getting and Cleaning Data/Week_4/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/tidydata.txt",row.names = FALSE, col.names = TRUE)


