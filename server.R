library(tidyverse)
library(plotly)
library(scales)


collisions_df <- read.csv("seattle-collisions.csv", stringsAsFactors = F)

server <- function(input, output) {
  output$intro <- renderText({
    return("test")
  })
}
