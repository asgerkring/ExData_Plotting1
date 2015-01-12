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

# We'll only have a single graph here
par(mfrow = c(1,1))
# Plot the graph with the relevant label
plot(
  x=PDT$DateTime,
  y=as.numeric(PDT$Global_active_power),
  type="l",
  ylab="Glboal Active Power (kilowatts)",
  xlab=""
  )

# Output to file
dev.copy(png, file="plot2.png")
dev.off()
