processUserData <-
  function(inFile, myModel,bin_size,alphabet_size,...) {
    ##### package checks #####
    library(shiny)
    library(stats)
    library(reshape)
    library(RWeka)
    library(rJava)
    
    ## RWeka package check "ordinalClassClassifier"
    tryCatch({
      WPM("load-package", "ordinalClassClassifier")
    }, error = function(e) {
      WPM("install-package", "ordinalClassClassifier")
      WPM("load-package", "ordinalClassClassifier")
    })
    
    ## script sources
    source("../main/rawDO2daily.R")
    source("../main/timeseries2Symbol.r")
    source("../main/modelMaker.R")
    source("../main/processUserData.R")
    
    ##### package checks end #####
    
    ##### unpack the inputs #####
    args = list(...) # contains varargin
    
    # isWrite check - write a file?
    if (is.null(args$isWrite)) {
      isWrite <- 0
    } else{
      isWrite <- args$isWrite
    }
    
    ##### unpack ends #####
    
    myList <- rawDO2daily(inFile)
    
    # file name
    tryCatch({
      ## if input was the filename
      inFName <- strsplit(inFile,"\\.")
      outFName <- paste(inFName[[1]][1], "SAX",sep = ".")
    }, error = function(e) {
    })
    
    myDates <- myList[1]
    myMatrix <-
      matrix(unlist(myList[2]), ncol = 49, byrow = FALSE)
    
    msize.X <- NCOL(myMatrix)
    msize.Y <- NROW(myMatrix)
    
    SAX.num <- NA
    SAX.str <- NA
    oldw <- getOption("warn")
    options(warn = -1)
    for (i in 1:msize.Y) {
      res.toss <-
        timeseries2Symbol(myMatrix[i,1:msize.X], bin_size, alphabet_size)
      SAX.num[i] <- res.toss
      SAX.str[i] <- res.toss$str_rep
    }
    options(warn = oldw)
    
    myData <- list(series = SAX.str)
    myData <- lapply(myData, as.character)
    myData$nominal <- NA
    myData$dataMatrix <- myMatrix
    
    ## get predictions for the training data
    myPredictions <- predict(myModel,
                             newdata = myData)
    
    myData$nominal <- myPredictions
    
    myOut <- as.data.frame(c(myDates,myData))
    colnames(myOut)[1] <- "Dates"
    colnames(myOut)[2] <- "SAX"
    colnames(myOut)[3] <- "Class"
    
    
    for(i in 1:49){
      colnames(myOut)[3+i] <- paste(as.character(i*0.5 - 0.5),"hr")
    }
    
    if (isWrite) {
      write.table(
        myOut, file = outFName, append = FALSE, quote = FALSE, sep = "\t",
        eol = "\n", na = "NA", dec = ".", row.names = FALSE,
        col.names = TRUE, qmethod = c("escape", "double"),
        fileEncoding = ""
      )
    } else {
      # print(myOut)
      return(myOut)
    }
  }