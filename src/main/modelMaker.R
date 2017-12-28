modelMaker <- function(bin_size, alphabet_size, modelType){
# make training model
source("../main/timeseries2Symbol.r")

# read training dataset
DF.toss <- read.table("../main/SAX_TrainingRaw.txt",header=FALSE, sep="\t")
DF.matrix <- data.matrix(DF.toss)

DF.toss <- read.table("../main/SAX_TrainingLabel.txt",header=FALSE, sep="\t")
DF.label <- data.matrix(DF.toss)

# SAX transformation
msize.X <- NCOL(DF.matrix)
msize.Y <- NROW(DF.matrix)


SAX.num <- NA
SAX.str <- NA

oldw <- getOption("warn") # warning off
options(warn = -1)
for(i in 1:msize.Y){
  res.toss <- timeseries2Symbol(DF.matrix[i,1:msize.X], bin_size, alphabet_size)
  # SAX.num[i] <- res.toss
  SAX.str[i] <- res.toss$str_rep
}
options(warn = oldw)

myData <- list(series = SAX.str)
myData <- lapply(myData, as.character)

## Model build
# # package check "RWeka"
# usePackage <- function(RWeka) {
#   if (!is.element(RWeka, installed.packages()[,1]))
#     install.packages("RWeka", dep = TRUE)
#   install("RWeka", character.only = TRUE)
# }
library(RWeka)

# RWeka package check "ordinalClassClassifier"
 tryCatch({
   WPM("load-package", "ordinalClassClassifier")
 },
 error = function(e){
  WPM("refresh-cache")
  WPM("install-package", "ordinalClassClassifier")
  WPM("load-package")
 }
 )
# browser()
## import filters and classifiers
# Logistic classifier
myClassifier.Logistic <- 
  make_Weka_classifier("weka.classifiers.functions.Logistic")

# ordinalClassClassifier
myClassifier.OrdinalClassClassifier <-
  make_Weka_classifier("weka.classifiers.meta.OrdinalClassClassifier")

# StringToWordVector filter
myFilter.StringToWordVector <-
  make_Weka_filter("weka.filters.unsupervised.attribute.StringToWordVector")

# FilteredClassifier
myClassifier.FilteredClassifier <-
  make_Weka_classifier("weka.classifiers.meta.FilteredClassifier")

## use SAX words to create attributes
myData$nominal <- as.factor(DF.label)

## run ordinalClassClassifier
# ordinal <- TRUE
if(modelType == 0){
myModel <- myClassifier.FilteredClassifier(
  nominal~.,
  myData,
  control = list(
    "-F", 
    "weka.filters.unsupervised.attribute.StringToWordVector -tokenizer \"weka.core.tokenizers.CharacterNGramTokenizer -min 1 -max 100\"",
    "-W",
    "weka.classifiers.meta.OrdinalClassClassifier",
    "--",
    "-W", 
    "weka.classifiers.functions.Logistic"
    )
  )
} else if (modelType == 1) {
  myModel <- myClassifier.FilteredClassifier(
    nominal~.,
    myData,
    control = list(
      "-F", 
      "weka.filters.unsupervised.attribute.StringToWordVector -tokenizer \"weka.core.tokenizers.CharacterNGramTokenizer -min 1 -max 100\"",
      "-W",
      "weka.classifiers.functions.Logistic"
    )
  )
} else {
  # browser()
  myData[[2]][which(as.numeric(myData[[2]]) <= modelType-9)] <- 0
  myData[[2]][which(as.numeric(myData[[2]]) > modelType-9)] <- 1
  myData[[2]] <- factor(myData[[2]],levels = c(0,1))
  
  myModel <- myClassifier.FilteredClassifier(
    nominal~.,
    myData,
    control = list(
      "-F", 
      "weka.filters.unsupervised.attribute.StringToWordVector -tokenizer \"weka.core.tokenizers.CharacterNGramTokenizer -min 1 -max 100\"",
      "-W",
      "weka.classifiers.functions.Logistic"
    )
  )
#   browser()
}

return(myModel)

}
