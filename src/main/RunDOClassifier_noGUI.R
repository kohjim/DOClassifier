source("processUserData.R")
source("modelMaker.R")

# data used
inFile <- "example.doobs"

word_length = 4
alphabet_number = 3

myModel <- modelMaker(word_length,alphabet_number,0)

out <- processUserData(
  inFile,
  myModel, # (input$bin_size, input$alphabet_size),
  word_length, # input$bin_size,
  alphabet_number, # input$alphabet_size,
  isWrite = FALSE
)
