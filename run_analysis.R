require(pylr)
# Read train and test data, 
data.filename <- c("data//train/X_train.txt", "data//test//X_test.txt")
data <- ldply(data.filename, read.table)

# Read labels, assign to colnames(data) to finish Step 1
label <- read.table("data/features.txt")[, 2]
colnames(data) <- label


# Extract activity id and corresponding label
activity.filename = c("data//train//y_train.txt", "data//test//y_test.txt")
activity <- ldply(activity.filename, read.table)
colnames(activity) <- c("activity_id")

activity.label <- read.table("data//activity_labels.txt", col.names=c("activity_id", "activity_label"))
activity <- merge(activity, activity.label)
# add it to data
data$activity_label <- activity$activity_label

# Similarly, extract subject id
subject.filename = c("data//train//subject_train.txt", "data//test//subject_test.txt")
subject <- ldply(subject.filename, read.table)

# Add it to data, thus finishing Step 3 and 4
data$subject_id <- subject[, 1]

# Extracting those colnames which contains "std()" and "mean()" 
# using customized filter function
# thus finish Step 2
contains_mean_std <- function (s) {
  return(grepl("-std()", s) || grepl("-mean()", s))
}

mean_std_data <- data[, sapply(label, contains_mean_std)]

# Calculate the mean for each (subject, activity) pair
result <- ddply(mean_std_data, .(subject_id, activity_label), numcolwise(mean))
