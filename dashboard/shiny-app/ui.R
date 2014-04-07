library(shiny)
library(ggplot2)

reactiveBar <- function (outputId)
{
  HTML(paste("<div id=\"", outputId, "\" class=\"shiny-network-output\" width=50% align=left><svg /></div>", sep=""))
}


if(.Platform$OS.type=="windows"){
  setwd('C:/Users/aalexander/Documents/Personal/big data competition - spring 2014/skullcandy/shiny-app/')
} else {
  setwd('/srv/shiny-server/shiny-app/')
}

dataset = read.csv('skullcandy.csv')
load("brands.Rda")
load("amazon_brands.Rda")
load("twitter_followers.Rda")

dataset$has_location = 0
ncharlatlon = sapply(as.character(dataset$lat.lon),FUN=nchar)
dataset[which(ncharlatlon>5),'has_location'] <- 1

dataset$social_buyer = round(runif(nrow(dataset)))
dataset$social_feeler = round(runif(nrow(dataset)))
dataset$social_hater = round(runif(nrow(dataset)))
dataset$social_leader = round(runif(nrow(dataset)))

shinyUI(pageWithSidebar(
  
  headerPanel("Skullcandy Explorer"),
  sidebarPanel(
    
    #sliderInput('sampleSize', 'Sample Size', min=1, max=nrow(dataset),
    #            value=min(1000, nrow(dataset)-1), step=500, round=0),
    checkboxGroupInput("brands", "Brands",
                       sort(amazon_brands)),
    checkboxGroupInput("prod_cat", "Product Categories",
                       c("HEADPHONES","WIRELESS_ACCESSORY","VIDEO_GAME_ACCESSORIES","CONSUMER_ELECTRONICS","PORTABLE_AUDIO"),
                       selected = "HEADPHONES")
    #selectInput('subgroup', 'Subgroup', brands),
    #selectInput('comp_brand', 'Compare Brand', c(None='.',sort(brands))),
    #selectInput('x', 'X', names(dataset)),
    #selectInput('y', 'Y', names(dataset), names(dataset)[[2]]),
    #selectInput('color', 'Color', c('None', names(dataset))),
    #checkboxInput('jitter', 'Jitter'),
    #checkboxInput('smooth', 'Smooth'),
    #selectInput('facet_row', 'Facet Row', c(None='.', names(dataset))),
    #selectInput('facet_col', 'Facet Column', c(None='.', names(dataset))),
    #selectInput('map_location', 'Map View', c('world','state'))
  ),
  
  mainPanel(
    h4("Total Brand Sentiment"),
    plotOutput('ts', height="400px"),
    h4("Amazon Product Reviews"),
    plotOutput('ts_bubble', height="500px"),
    dataTableOutput('reviews'),
    tableOutput("view"),
    h4("Twitter Followers"),
    includeHTML("parsets.js")
    #plotOutput('plot_map',width="50%", height="400px"),
    #plotOutput('plot',width="50%", height="400px")
  )
))