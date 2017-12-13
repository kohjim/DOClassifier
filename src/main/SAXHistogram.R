SAXHistogram <- function(userDataProcessed,bin_size,alphabet_size){
   
  if (alphabet_size == 2){
    alphabets = c("a","b")
  } else if(alphabet_size == 3){
    alphabets = c("a","b","c")
  } else if(alphabet_size == 4){
    alphabets = c("a","b","c","d")
  } else if(alphabet_size == 5){
    alphabets = c("a","b","c","d","e")
  } else if(alphabet_size == 6){
    alphabets = c("a","b","c","d","e","f")
  }
  
  if (bin_size == 2){
    alphabetCombn = expand.grid(alphabets,alphabets)
  } else if (bin_size == 3){
    alphabetCombn = expand.grid(alphabets,alphabets,alphabets)
  } else if (bin_size == 4){
    alphabetCombn = expand.grid(alphabets,alphabets,alphabets,alphabets)
  } else if (bin_size == 5){
    alphabetCombn = expand.grid(alphabets,alphabets,alphabets,alphabets,alphabets)
  } else if (bin_size == 6){
    alphabetCombn = expand.grid(alphabets,alphabets,alphabets,alphabets,alphabets,alphabets)
  }
  
  cmbLength = NROW(alphabetCombn)
  
  listAll <- NA
  for (i in 1:cmbLength){
    if (bin_size == 2){
      listAll[i] = paste(alphabetCombn[i,2],
                         alphabetCombn[i,1],
                         sep = "")
    } else if(bin_size == 3){
      listAll[i] = paste(alphabetCombn[i,3],
                         alphabetCombn[i,2],
                         alphabetCombn[i,1],
                         sep = "")
      alphabets = c("a","b","c")
    } else if(bin_size == 4){
      listAll[i] = paste(alphabetCombn[i,4],
                         alphabetCombn[i,3],
                         alphabetCombn[i,2],
                         alphabetCombn[i,1],
                         sep = "")
    } else if(bin_size == 5){
      listAll[i] = paste(alphabetCombn[i,5],
                         alphabetCombn[i,4],
                         alphabetCombn[i,3],
                         alphabetCombn[i,2],
                         alphabetCombn[i,1],
                         sep = "")
    } else if(bin_size == 6){
      listAll[i] = paste(alphabetCombn[i,6],
                         alphabetCombn[i,5],
                         alphabetCombn[i,4],
                         alphabetCombn[i,3],
                         alphabetCombn[i,2],
                         alphabetCombn[i,1],
                         sep = "")
    }
  }
  
  names(listAll) <- names(userDataProcessed$SAX) 

  myDataFactor <- factor(as.character(userDataProcessed$SAX), levels = listAll)
  barplot(table(myDataFactor))
  
  }