# Run DOClassifier ver 0.8 for PC
tryCatch({
  library(shiny)
}, error = function(e) {
  install.packages("shiny")
  library(shiny)
})

runApp("main")