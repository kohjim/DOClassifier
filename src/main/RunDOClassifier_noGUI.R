RunDOClassifier_noGUI <- function(inFileName, word_length, alphabet_number){
  
  source("processUserData.R")
  source("modelMaker.R")
  
  if (missing(word_length)){
    word_length = 4
  }
  
  if (missing(alphabet_number)){
    alphabet_number = 3
  }
  
  myModel <- modelMaker(word_length,alphabet_number,0)
  
  out <- processUserData(
    inFile,
    myModel, # (input$bin_size, input$alphabet_size),
    word_length, # input$bin_size,
    alphabet_number, # input$alphabet_size,
    isWrite = FALSE
  )
  
  return(out)
}