# Read the data from the zip file directly
colclasses <- c("character", "character", rep("numeric",7))
data <- read.csv(unz("exdata-data-household_power_consumption.zip", 
                     "household_power_consumption.txt"), 
                 colClasses = colclasses, 
                 na.strings=c("?"), 
                 sep=";" )


# Paste the date and time fields into a new field called DateTime
data <- within(data, DateTime <- paste(Date, Time, sep=" "))

# Remove data to save memory
data$Date = NULL
data$Time = NULL

# Convert DateTime from character to a real Date
data$DateTime <- as.POSIXct(strptime(data$DateTime, 
                                     format = "%d/%m/%Y %H:%M:%S"))

data = subset(data, DateTime >= as.POSIXct("2007-02-01") & 
              DateTime < as.POSIXct("2007-02-03"))


# Plot 4
png(filename="plot4.png", width = 480, height = 480)
par(mfrow=c(2,2))

with(data, { 
  plot(DateTime, Global_active_power, type="l", 
       ylab="Global Active Power", xlab="")
  plot(DateTime, Voltage, type="l", 
       ylab="Voltage", xlab="datetime")
  plot(DateTime, Sub_metering_1, type="l", 
       ylab="Energy sub metering", xlab="", 
       ylim=range(c(Sub_metering_1,Sub_metering_2,Sub_metering_3)))
  lines(DateTime, Sub_metering_2, col="red", 
        ylim=range(c(Sub_metering_1,Sub_metering_2,Sub_metering_3)))
  lines(DateTime, Sub_metering_3, col="blue", 
        ylim=range(c(Sub_metering_1,Sub_metering_2,Sub_metering_3)))
  legend("topright", c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"), 
         lty=1,  col=c("black","red","blue"), bty="n")
  plot(DateTime, Global_reactive_power, type="l", ylab="Global_reactive_power", 
       xlab="datetime")
})

dev.off()