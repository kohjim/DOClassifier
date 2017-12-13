timeseries2symbol_bak <- function(dataIn,PAA_n,bin_n){
  # was a temporal solution while figuring other method
  # - translated from Lin, Keogh et al
  # dataIn col = incidents, row = time
  #
  
  dataIn <- t(dataIn)
  
  msize.X <- NCOL(dataIn) # incidents number
  msize.Y <- NROW(dataIn) # timeseries length
  
  repMatrix <-matrix(data = NA, nrow = msize.Y*PAA_n, ncol = msize.X)
  for(i in 1:msize.X){
    repMatrix[,i] <- rep(dataIn[,i],each=PAA_n)
  }
  dataIn_bak = dataIn
  dataIn <- repMatrix
  
  if (bin_n == 2){
    bin_points  = c(-100,0)
  }  else if (bin_n == 3){
    bin_points  = c(-100,-0.43,0.43)
  }  else if (bin_n == 4){
    bin_points  = c(-100,-0.67,0,0.67)
  }  else if (bin_n == 5){
    bin_points  = c(-100,-0.84,-0.25,0.25,0.84)
  }  else if (bin_n == 6){
    bin_points  = c(-100,-0.97,-0.43,0,0.43,0.97)
  }  else if (bin_n == 7){
    bin_points  = c(-100,-1.07,-0.57,-0.18,0.18,0.57,1.07)
  }  else if (bin_n == 8){
    bin_points  = c(-100,-1.15,-0.67,-0.32,0,0.32,0.67,1.15)
  }  else if (bin_n == 9){
    bin_points  = c(-100,-1.22,-0.76,-0.43,-0.14,0.14,0.43,0.76,1.22)
  }  else if (bin_n == 10){
    bin_points  = c(-100,-1.28,-0.84,-0.52,-0.25,0.,0.25,0.52,0.84,1.28)
  }
  
  msize.X <- NCOL(dataIn) # incidents number
  msize.Y <- NROW(dataIn) # timeseries length
  
  win_size = msize.Y / PAA_n
  
  sds <- NA
  means <- NA
  data.sdmean = matrix(data = NA, nrow = msize.Y, ncol = msize.X)
  data.PAA = matrix(data = NA, nrow = PAA_n, ncol = msize.X)
  cuts = 1:(PAA_n-1)
  cuts = c(1,cuts*win_size,msize.Y)
  
  for(i in 1:msize.X){
    sds[i] = sd(dataIn_bak[,i],na.rm=TRUE)
    means[i] = mean(dataIn_bak[,i],na.rm=TRUE)
    data.sdmean[,i] = (dataIn[,i] - means[i])/sds[i]

    for (j in 1:PAA_n){
      data.PAA[j,i] = mean(
        data.sdmean[cuts[j]:cuts[j+1],i],
        na.rm=TRUE
      )
    }

  }
  
  data.SAX <- data.PAA
  data.SAXstr <- list()
  dictionary = c("a","b","c","d","e","f","g","h","i","j","k")
  for (i in 1:bin_n){
    data.SAX <- ifelse(data.PAA>bin_points[i],i,data.SAX)
    data.SAXstr <- ifelse(data.PAA>bin_points[i],dictionary[i],data.SAXstr)
  }
  
  data.SAXword <- list()
  for(i in 1:msize.X){
    data.SAXword[i] <- paste(data.SAXstr[,i], collapse = '')
  }
  
  data.SAXword <- list(series = data.SAXword)
  data.SAXword <- lapply(data.SAXword, as.character)
  # data.SAXword
  return(data.SAXword)
}