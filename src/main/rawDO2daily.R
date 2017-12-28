rawDO2daily <- function(doobsFile){
  # Import doobs file
  # DF.toss <- read.table("mendota.doobs",header=TRUE, sep="\t")
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
  DF$julian<- julian(DF$DateTime)
  
  ts.floor <- as.numeric(floor(DF$julian[1]))
  ts.ceil <- as.numeric(ceiling(DF$julian[length(DF$julian)]))
  
  # new time index
  new.DateTime <- seq(as.Date(ts.floor,origin=as.Date("1970-01-01")), 
                    as.Date(ts.ceil,origin=as.Date("1970-01-01")),
                    by=as.difftime(30,units='mins'),
                    format = "%Y-%m-%d %H:%M")
  
  new.Dates <- seq(as.Date(ts.floor,origin=as.Date("1970-01-01")), 
                      as.Date(ts.ceil,origin=as.Date("1970-01-01")),
                      by=as.difftime(1,units='days'),
                      format = "%Y-%m-%d")
  
  new.julian <- julian(new.DateTime)
  new.julian.floor <- as.numeric(floor(new.julian))
  new.julian.frac <- new.julian - new.julian.floor
  # DF.merge <- merge(DF, ts.new, all = TRUE, by = DF$DateTime)
  
  # package check "stats"
#   usePackage <- function(stats) {
#     if (!is.element(stats, installed.packages()[,1]))
#       install.packages("stats", dep = TRUE)
#     install("stats", character.only = TRUE)
#   }
  library(stats)
  
  # package check "reshape"
  usePackage <- function(reshape) {
    if (!is.element(reshape, installed.packages()[,1]))
      install.packages("reshape", dep = TRUE)
    install("reshape", character.only = TRUE)
  }
  library(reshape)
  
  new.approx <- approxfun(DF$julian,DF$doobs,method="linear")
  new.Data <- new.approx(new.julian)
  
  DF.new <- data.frame(new.julian.floor,
                 new.julian.frac,
                 new.Data)

  # make non-existance data as NA
  ismemberInd <- is.element(new.julian.floor+new.julian.frac, DF$julian)
  DF.new$new.Data[!ismemberInd] <- NA
  
  # reshape the data
  DF.new.reshaped <- cast(DF.new,new.julian.floor ~ new.julian.frac)
  DF.new.reshaped$'1' <- 
    c(DF.new.reshaped$`0`[2:length(DF.new.reshaped$new.julian.floor)],NA)
  DF.matrix <- data.matrix(DF.new.reshaped[2:50])
  #   myAns <- as.data.frame(new.Dates)
  #   myAns$matrix <- as.data.frame(DF.matrix)
  return(list(Dates <- new.Dates, DF.matrix <- DF.matrix))
}