# Read the data from the zip file directly
colclasses <- c("character", "character", rep("numeric",7))
data <- read.csv(unz("exdata-data-household_power_consumption.zip", "household_power_consumption.txt"), colClasses = colclasses, na.strings=c("?"), sep=";" )


# Paste the date and time fields into a new field called DateTime
data <- within(data, DateTime <- paste(Date, Time, sep=" "))

# Remove data to save memory
data$Date = NULL
data$Time = NULL

# Convert DateTime from character to a real Date
data$DateTime <- as.POSIXct(strptime(data$DateTime, format = "%d/%m/%Y %H:%M:%S"))

data = subset(data, DateTime >= as.POSIXct("2007-02-01") & DateTime < as.POSIXct("2007-02-03"))

# Plot 2  
png(filename="plot2.png", width = 480, height = 480)
with(data, plot(DateTime, Global_active_power, type="l", ylab="Global Active Power (kilowatts)", xlab=""))
dev.off()