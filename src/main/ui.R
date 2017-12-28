shinyUI(fluidPage(
  fluidRow(column(12,div(style = "height:14px"))),
  fluidRow(
    column(2,
           wellPanel(
             fileInput('doobsFile', 'Choose a .doobs file to classify',
                       accept = c(
                         'text/csv',
                         'text/comma-separated-values',
                         'text/tab-separated-values',
                         'text/plain',
                         '.csv',
                         '.doobs'
                       )
             ),
             
             tags$hr(),
             
             downloadButton('downloadData', 'Download'),
             
             tags$hr(),
             tags$hr(),
             
             sliderInput("binary_threshold", "Binary cutting point (threshold)", 0, 7, 5, step = 1, round = FALSE,
                         ticks = TRUE, animate = FALSE,
                         width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL,
                         timezone = NULL, dragRange = TRUE),
             
             tags$hr(),
             tags$hr(),
             
             sliderInput("word_length", "Number of letters", 2, 6, 4, step = 1, round = FALSE,
                         ticks = TRUE, animate = FALSE,
                         width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL,
                         timezone = NULL, dragRange = TRUE),
             
             tags$hr(),
             tags$hr(),
             
             sliderInput("alphabet_number", "Number of alphabet", 2, 6, 3, step = 1, round = FALSE,
                         ticks = TRUE, animate = FALSE,
                         width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL,
                         timezone = NULL, dragRange = TRUE),
             
             tags$hr()
           )),
    
    column(5,
           p("Training data"),
           plotOutput("modelPlot")
           ),
    column(5,
           p("Your data (example if no input)"),
           plotOutput("userPlot")
           ),
    

    column(10, offset = 0,
           p("Shape distribution of your data"),
           plotOutput("userHist")
           )
  
  )
))