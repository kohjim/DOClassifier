modelTrainPlot <- function(binary_threshold,myData,myData.stdmean){
  

  msize.X <- NCOL(myData.stdmean)
  msize.Y <- NROW(myData.stdmean)
  
  myClass <- NA

  for(i in 1:8){
    myClass[i] <- as.data.frame(1:msize.Y)
    myClass[[i]][!(myData[[2]] %in% c(i-1))] <- NA
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
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[6]]),]),
            type="l",
            add=TRUE,
            col='black')
  }
  
  # threshold bet 4-5
  if(binary_threshold <= 5){
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[5]]),]),
            type="l",
            add=TRUE,
            col='black')
  }
  
  # threshold bet 3-4
  if(binary_threshold <= 4){
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[4]]),]),
            type="l",
            add=TRUE,
            col='black')
  }
  
  # threshold bet 2-3
  if(binary_threshold <= 3){
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[3]]),]),
            type="l",
            add=TRUE,
            col='black')
  }
  
  # threshold bet 1-2
  if(binary_threshold <= 2){
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[2]]),]),
            type="l",
            add=TRUE,
            col='black')
  }
  
  # threshold bet 0-1, not happening
  if(binary_threshold <= 1){
    matplot(0:48/2,t(myData.stdmean[!is.na(myClass[[1]]),]),
            type="l",
            add=TRUE,
            col='black')
  }
  
}