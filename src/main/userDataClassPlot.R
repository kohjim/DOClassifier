userDataClassPlot <- function(userDataProcessed, binary_threshold){

  myMatrix <- as.matrix(userDataProcessed[4:52])
  msize.X <- NCOL(myMatrix)
  msize.Y <- NROW(myMatrix)
  
  #### standard mean transformation
  myData.std <- NA
  myData.mean <- NA
  myData.stdmean <- myMatrix
  for(i in 1:msize.Y){
    myData.std[i] <- sd(myMatrix[i,])
    myData.mean[i] <- mean(myMatrix[i,])
    myData.stdmean[i,] <- (myMatrix[i,]-myData.mean[i])/myData.std[i]
  }
  
  myClass <- NA
  for(i in 1:8){
    myClass[i] <- as.data.frame(1:msize.Y)
    myClass[[i]][!(userDataProcessed[[3]] %in% c(i-1))] <- NA
  }

  # threshold bet 6-7
  modelTrainPlot <- matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[7]]),]),
          type = "l",
          col = 'black',
          xlim = c(0,24),
          ylim = c(-3,3),
          xlab = "Time of day",
          ylab = "Normalized dissolved oxygen concentration")

  # threshold bet 5-6
  if(binary_threshold <= 6){
    tryCatch({
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[6]]),]),
            type="l",
            add=TRUE,
            col='black')
    }, error = function(e) {
      lines(0:48/2,t(myData.stdmean[!is.na(myClass[[6]]),]),
            col="black")
    }, error = function(e) {})
  }
  
  # threshold bet 4-5
  if(binary_threshold <= 5){
    tryCatch({
      matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[5]]),]),
              type="l",
              add=TRUE,
              col='black')
    }, error = function(e) {
      lines(0:48/2,t(myData.stdmean[!is.na(myClass[[5]]),]),
            col="black")
    }, error = function(e) {})
  }
  
  # threshold bet 3-4
  if(binary_threshold <= 4){
    tryCatch({
      matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[4]]),]),
              type="l",
              add=TRUE,
              col='black')
    }, error = function(e) {
      lines(0:48/2,t(myData.stdmean[!is.na(myClass[[4]]),]),
            col="black")
    }, error = function(e) {})
  }
  
  # threshold bet 2-3
  if(binary_threshold <= 3){
    tryCatch({
      matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[3]]),]),
              type="l",
              add=TRUE,
              col='black')
    }, error = function(e) {
      lines(0:48/2,t(myData.stdmean[!is.na(myClass[[3]]),]),
            col="black")
    }, error = function(e) {})
  }
  
  # threshold bet 1-2
  if(binary_threshold <= 2){
    tryCatch({
      matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[2]]),]),
              type="l",
              add=TRUE,
              col='black')
    }, error = function(e) {
      lines(0:48/2,t(myData.stdmean[!is.na(myClass[[2]]),]),
            col="black")
    }, error = function(e) {})
  }
  
  # threshold bet 0-1, not happening
  if(binary_threshold <= 1){
    tryCatch({
      matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[1]]),]),
              type="l",
              add=TRUE,
              col='black')
    }, error = function(e) {
      lines(0:48/2,t(myData.stdmean[!is.na(myClass[[1]]),]),
            col="black")
    }, error = function(e) {})
  }
}