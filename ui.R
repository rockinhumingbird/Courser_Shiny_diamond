#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
# Read data
library(ggplot2)
library(plotly)
library(data.table)
library(DT)
library(shiny)
library(shinydashboard)
library(markdown)

data(diamonds)
nm<-names(diamonds)


shinyUI(navbarPage("Diamonds",
           #multipage user interface that includes a navigation bar
           tabPanel("Graphs",
                    sidebarPanel(
                        
                            sliderInput(inputId = 'sampleSize', label = 'Sample Size', min = 1, max = nrow(diamonds),
                                        value = 1000, step = 500, round = 0),
                            selectInput(inputId = 'x', label = 'X', choices = nm, selected = "carat"),
                            selectInput(inputId = 'y', label = 'Y', choices = nm, selected = "price"),
                            selectInput(inputId = 'color', label = 'Color', choices = nm, selected = "clarity"),
                            selectInput(inputId = 'facet_row', label = 'Facet Row', c(None = '.', nm), selected = "clarity"),
                            selectInput(inputId = 'facet_col', label = 'Facet Column', c(None = '.', nm)),
                            sliderInput(inputId = 'plotHeight', 'Height of plot (in pixels)', 
                                        min = 100, max = 2000, value = 1000),
                            # Checkbox Input:
                            checkboxInput('jitter','jitter',value=TRUE),
                            checkboxInput('smooth','smooth',value=TRUE),
                            actionButton(inputId = "refresh", label = "Simulate New Data" ,
                                         icon = icon("fa fa-refresh"))
                            ),#End of sidebar panel
                    mainPanel(
                        plotlyOutput(
                            outputId = ("trendPlot"),height="900px")
                            )),#end of tabPanel1
           
           tabPanel(
             "filter",
            h3("Provide information about diamonds and the characteristics that you want", align="center"), 
            sidebarPanel(
              
                  # Choose features
                selectInput(inputId = 'filter1','filter1:cut',choices = unique(diamonds$cut)),
       
                selectInput(inputId = 'filter2','filter2:clarity',choices=unique(diamonds$clarity)),

                selectInput(inputId = 'filter3','filter3:color',choices = unique(diamonds$color)),
                sliderInput(inputId = 'filter4', label =  'filter4:carat', min=0.20, max=5.01, value=c(0.20,5.01), step=0.5, round=0),
                sliderInput(inputId = 'filter5', label = 'filter5:price', min=326, max=18823, value=c(326,18823), step=10)
                ), #end of sidebarpanel
            mainPanel(
                 h3(textOutput("Summarytext")),
                box(width=9,dataTableOutput('mydata')),
                downloadButton('x3', 'Download Filtered Data'),
                plotOutput('plot',height="300px",width = "500px")
                )),#end of tabpanel2
          
           tabPanel("about",
                    mainPanel(includeMarkdown("about.md"))
                 )#End of tabpanel 3
      
           
)
)