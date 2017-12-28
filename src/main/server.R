## install, load and identify packages
##### package and source check #####
options(repos = c(CRAN = "https://ftp.osuosl.org/pub/cran/", 
                  CRANextra = "https://cran.cnr.berkeley.edu/"))
# cat(file=stderr())
# dump.frames(dumpto = "last.dump", to.file = TRUE,
#             include.GlobalEnv = FALSE)

    ## package check "shiny"
    tryCatch({
      library(shiny)
    }, error = function(e) {
      install.packages("shiny")
      library(shiny)
    })
# library(shiny)
    ## package check "stats"
    tryCatch({
      library(stats)
    }, error = function(e) {
      install.packages("stats")
      library(stats)
    })
# library(stats)
#  package check "reshape"
    tryCatch({
      library(reshape)
    }, error = function(e) {
      install.packages("reshape")
      library(reshape)
    })
# library(reshape)
# library check "RWeka"
    tryCatch({
      library(RWeka)
    }, error = function(e) {
      install.packages("RWeka")
      library(RWeka)
    })
# library(RWeka)
    ## library check "rJava"
    tryCatch({
      library(rJava)
    }, error = function(e) {
      install.packages("rJava")
      library(rJava)
    })
# library(rJava)

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
source("../main/modelTrainPlot.R")
source("../main/userDataClassPlot.R")
source("../main/SAXHistogram.R")
source("../main/makeModelForShinyPlot.R")
source("../main/userDataClassPlot.R")

##### package and source check ends #####

##### server.R #####
# increase max allowed file upload
options(shiny.maxRequestSize = 20 * 1024 ^ 2) # MB max
# myModel <- modelMaker(4, 4)
output <- NA

######## start Shiny ########
shinyServer(function(input, output) {

  # model plot
  output$modelPlot <- renderPlot({
    modelTrainPlot(input$binary_threshold,
                   makeModelForShinyPlot(input$word_length,input$alphabet_number)$myData,
                   makeModelForShinyPlot(input$word_length,input$alphabet_number)$myData.stdmean)
  })

  # reactive which processes userinput
  userDataProcessed <- reactive({
    inFile <- input$doobsFile
    if (is.null(inFile)){
      inFile <- "example.doobs"
    }
    
    processUserData(
      inFile,
      modelMaker(input$word_length,input$alphabet_number,0), # (input$bin_size, input$alphabet_size),
      input$word_length, # input$bin_size,
      input$alphabet_number, # input$alphabet_size,
      isWrite = FALSE
    )
  })
  
  # userdata plot
  output$userPlot <- renderPlot({
    userDataClassPlot(userDataProcessed(),input$binary_threshold)
  })
  
  # Histogram plot
  output$userHist <- renderPlot({
    SAXHistogram(userDataProcessed(),input$word_length,input$alphabet_number)
  })
  
  # Let user download their results
  output$downloadData <- downloadHandler(
    filename <- "SAXoutput.txt",
    content = function(filename) {
      write.table(
        userDataProcessed(),
        filename,
        append = FALSE, quote = FALSE, sep = "\t",
        eol = "\n", na = "NA", dec = ".", row.names = FALSE, #eol = "\r\n"
        col.names = TRUE, qmethod = c("escape", "double"),
        fileEncoding = ""
      )
    }
  )
})

##### end Shiny #####