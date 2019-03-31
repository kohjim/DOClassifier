# DOClassifier v1.0

A tool to classify lake free surface DO observations

## Getting Started

A manual to come soon.

Web based version is available from: http://kmuraoka.com/DOClassifier/ 

### Note for linux users

"Error java.lang.ClassNotFoundException" may appear on linux machine, which is reportedly an issue of environmental settings of rJava. 

Executing “export LD_LIBRARY_PATH=/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server” and “sudo R CMD javareconf” fixed the issue in our Ubuntu server, but if that is difficult, please use the web version for now.

### Setup

* to be updated

#### With GUI

Download the contents of src folder.
(1) In R, set the "src" folder as the working dir using setwd("").
(2) type source("RunDOClassifier.R")
(3) type RunDOClassifier
(4) "upload" .doobs file and save the results through "download"

#### Without GUI
Download the contents of src folder.
(1) In R, set the "main" folder as the working dir using setwd("").
(2) follow the code in "example_without_GUI.R"

## Example

Example doobs file (Mendota) is in the example_doobs folder

## Versioning

#### ver 1.01 2019/03/31


## Citation

Please cite:
Muraoka, K., Hanson, P., Frank, E., Jiang, M., Chiu, K., Hamilton, D., 2018. A data mining approach to evaluate suitability of dissolved oxygen sensor observations for lake metabolism analysis. Limnol. Oceanogr. Methods 16, 787–801. https://doi.org/10.1002/lom3.10283

## Authors

Muraoka, K., Hanson, P., Frank, E., Jiang, M., Chiu, K., Hamilton, D

kohji.muraoka-gmail-com

## License


## Acknowledgments
* Anonymous experts for the label creation