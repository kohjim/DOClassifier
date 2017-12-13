makeModelForShinyPlot <- function(word_length, alphabet_number){
  #word_length = input$word_length        # number of SAX bins (i.e. binning in the value axes)
  #alphabet_number = input$alphabet_number   # number of PAA bins (i.e. sectioning in the time axes)

  source("../main/timeseries2Symbol.r")
  
  DF.toss <- read.table("../main/SAX_TrainingRaw.txt",header=FALSE, sep="\t")
  DF.matrix <- data.matrix(DF.toss)
  
  DF.toss <- read.table("../main/SAX_TrainingLabel.txt",header=FALSE, sep="\t")
  DF.label <- data.matrix(DF.toss)
  
  # SAX transformation
  msize.X <- NCOL(DF.matrix)
  msize.Y <- NROW(DF.matrix)
  
  SAX.num <- NA
  SAX.str <- NA
  
  for(i in 1:msize.Y){
    res.toss <- timeseries2Symbol(DF.matrix[i,1:msize.X], word_length, alphabet_number)
    # SAX.num[i] <- res.toss
    SAX.str[i] <- res.toss$str_rep
  }
  
  myData <- list(series = SAX.str)
  myData <- lapply(myData, as.character)
  
  myData$nominal <- as.factor(DF.label)
  
  # standard mean transformation
  myData.std <- NA
  myData.mean <- NA
  myData.stdmean <- DF.matrix
  for(i in 1:msize.Y){
    myData.std[i] <- sd(DF.matrix[i,])
    myData.mean[i] <- mean(DF.matrix[i,])
    myData.stdmean[i,] <- (DF.matrix[i,]-myData.mean[i])/myData.std[i]
  }
  
  varOut <- list()
  varOut$myData <- myData
  varOut$myData.std <- myData.std
  varOut$myData.mean <- myData.mean
  varOut$myData.stdmean <- myData.stdmean
  
  return(varOut)
}