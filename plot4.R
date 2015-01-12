# Assignment 1, Exploratory Data Analisys
# Step 1 - read the data
# all_rows <- read.table("data/household_power_consumption.txt", header=TRUE, nrows=9)

# Step 2 - strip irrelevenant dates
# power_consumption <- subset(all_rows, Date=="01/")
# The data is read using fread from the data.table package. Only the lines containing the
# dates we are interested in are read.
#
# For dates and months < 10, there are not leading zeros. Thus, the selection is on the
# dates 1/2/2007 and 2/2/2007, as opposed to 01/02/2007 and 02/02/2007
#
# We will use fread so data.table package must be loaded

powerdata <- "data/household_power_consumption.txt"
PD <- fread(paste("grep \"^[12]/2/2007\"", powerdata), na.strings = "?")
# Headers a "grepped out", and must be restored

names <- colnames(fread(powerdata, nrows=0))

setnames(PD, names)

# Add a column with combined date/time information
PDT <- transform(PD, DateTime = strptime(paste(PD$Date, PD$Time), format="%d/%m/%Y %H:%M:%S", tz="EST"))


# Specify a 2x2 "box" for the plots
par(mfrow = c(2,2))
with(PDT, {
#Plot the chart form plot 2
  plot(
    x=PDT$DateTime,
    y=as.numeric(PDT$Global_active_power),
    type="l",
    ylab="Glboal Active Power (kilowatts)",
    xlab=""
  )
  
  plot(
    x=PDT$DateTime,
    y=as.numeric(PDT$Voltage),
    type="l",
    ylab="Voltage",
    xlab="datetime"
  )
  
  plot(
    x=PDT$DateTime,
    y=as.numeric(PDT$Sub_metering_1),
    type="l",
    ylab="Energy sub metering",
    xlab=""
  )
  # Then add the next datapoints - red and blue
  lines(x=PDT$DateTime, y=as.numeric(PDT$Sub_metering_2), col="red")
  
  lines(x=PDT$DateTime, y=as.numeric(PDT$Sub_metering_3), col="blue")
  legend("topright", lty=1, col=c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
  
  plot(
    x=PDT$DateTime,
    y=as.numeric(PDT$Global_reactive_power),
    type="l",
    ylab="Glboal_reactive_power",
    xlab="datetime"
  )
  
})

# Output to file
dev.copy(png, file="plot4.png")
dev.off()
