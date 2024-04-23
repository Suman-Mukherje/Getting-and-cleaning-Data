# Step 1: Downloading and unzip the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "UCI_HAR_Dataset.zip")
unzip("UCI_HAR_Dataset.zip")

# Step 2: Reading the data into R
# Load required packages
library(dplyr)

# Reading feature names
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("index", "feature"))

# Reading activity labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("activity_id", "activity"))

# Reading training data
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$feature)

# Reading training labels
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "activity_id")

# Reading test data
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$feature)

# Reading test labels
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "activity_id")

# Step 3: Mergeing the training and test sets
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)

# Step 4: Extracting only the measurements on the mean and standard deviation
# Subset the features dataset to include only mean and std features

mean_std_features <- grep("mean\\(\\)|std\\(\\)", features$feature)
X_mean_std <- X[, mean_std_features]

# Step 5: Useing descriptive activity names
# Merge activity labels with the activity ids

activity_labels <- data.frame(activity_id = 1:6, activity = activity_labels$activity)
y <- merge(y, activity_labels, by = "activity_id", all.x = TRUE)

# Step 6: Label the dataset with descriptive variable names
# Clean up feature names

names(X_mean_std) <- gsub("\\()", "", features$feature[mean_std_features])
names(X_mean_std) <- gsub("^t", "time_", names(X_mean_std))
names(X_mean_std) <- gsub("^f", "frequency_", names(X_mean_std))
names(X_mean_std) <- gsub("Acc", "Acceleration", names(X_mean_std))
names(X_mean_std) <- gsub("Gyro", "Gyroscope", names(X_mean_std))
names(X_mean_std) <- gsub("Mag", "Magnitude", names(X_mean_std))

# Checking Column names
colnames(X_mean_std)

# Step 7: Createing a tidy data set with the average of each variable for each activity and each subject
tidy_data <- X_mean_std %>% group_by_all() %>% summarise_all(mean)

# Step 8: Writeing the tidy data set to a file
write.table(tidy_data, file = "tidy_data.txt", row.names = FALSE)
