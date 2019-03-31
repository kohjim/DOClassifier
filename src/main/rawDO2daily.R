rawDO2daily <- function(doobsFile){
  # this use data.table - not yet configured in the server
  # Import doobs file

  Sys.setenv(tz = 'UTC')
  
  DF.toss <- tryCatch({
    read.table(doobsFile$datapath,header=TRUE, sep="\t")
  },
  error = function(e) {
    read.table(doobsFile,header=TRUE, sep="\t")
  })
  
  colnames(DF.toss)[1] <- "DateTime"
  colnames(DF.toss)[2] <- "doobs"
  
  DF <- DF.toss[,1:2]
  DF <- DF[!duplicated(DF$DateTime),]
  DF$DateTime <- strptime(DF$DateTime,"%Y-%m-%d %H:%M",tz='UTC')
  DF$julian <- julian(DF$DateTime)
  
  DF$floorToDay <- as.POSIXct(
    as.numeric(lapply(as.numeric(as.POSIXct(DF$DateTime))/60/60/24, floor))*60*60*24,
    origin = '1970-01-01 00:00:00 UTC'
  )
  
  DF$floorTo30min <- as.POSIXct(
    as.numeric(lapply(as.numeric(as.POSIXct(DF$DateTime))/60/30, floor))*60*30,
    origin = '1970-01-01 00:00:00 UTC'
  )
  
  
  # aggregate into 30 min using data.table
  DT <- data.table(
    as.data.frame(
      c(as.data.frame(DF$doobs),as.data.frame(DF$floorTo30min))
    )
  )
  colnames(DT) <- c("doobs","floorTo30min")
  
  DF.floorTo30min <- as.data.frame(
    DT[,
       list(doobs = mean(doobs, na.rm = TRUE)),
       by = list(floorTo30min)]
    )
  colnames(DF.floorTo30min)[1] <- "Dates"
  
  ### from here new
  # browser()
  ## for every dates make 0:00 to 24:00 30 min sequence
  library(data.table)
  
  # make new dates array with no time information
  ts.floor <- as.numeric(lapply(as.numeric(as.POSIXct(DF$DateTime))/60/60/24, floor))*60*60*24 # or use DF$floor
  ts.uniqueDates <- unlist(unique(ts.floor))
  
  # make new time array with no dates information
  ts.time <- as.numeric(seq(from = 0, to = 24, by = 0.5))*60*60
  
  # new time sequence in matrix
  ts.datetimemat <-
    matrix(rep(ts.uniqueDates, length(ts.time)) , ncol = length(ts.uniqueDates) , byrow = TRUE) + # unique dates matrix
    t(matrix(rep(ts.time, length(ts.uniqueDates)) , ncol = length(ts.time) , byrow = TRUE)) # unique time matrix
  
  # new time sequence in vector
  ts.datetimevec <- matrix(
    ts.datetimemat,
    nrow=ncol(ts.datetimemat)*nrow(ts.datetimemat),
    byrow=T)
  
  # new time sequence in POSIXct format in vector
  ts.new <- as.data.frame(as.POSIXct(ts.datetimevec, origin = '1970-01-01 00:00.00 UTC'))
  colnames(ts.new) = "Dates"
  
  # assign all data into the new sequence
  newDF <- merge(
    x = ts.new,
    y = DF.floorTo30min,
    by = "Dates",
    all = TRUE
  )
  
  # vector to matrix
  newMat <-     # transpose so that col = time
    as.data.frame(
      t(
        matrix(newDF$doobs,
               nrow = length(ts.time))
      )
    )
  
  # return
  return(list(Dates <- ts.uniqueDates, DF.matrix <- newMat))
}
