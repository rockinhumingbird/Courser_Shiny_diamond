#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  ### Saving data:
  dataset <- reactive({
    diamonds[sample(nrow(diamonds), input$sampleSize),]
    
  })
  ## First output "graphs"
  output$trendPlot <- renderPlotly({
    # build graph with ggplot syntax
    p <- ggplot(dataset(), 
                aes_string(x = input$x, y = input$y, color = input$color)) + 
      geom_point()
    # add it if at least one facet column/row is specified
    facets <- paste(input$facet_row, '~', input$facet_col)
    if (facets != '. ~ .') 
      p <- p + facet_grid(facets)
    
    # smoothing
    if (input$jitter)
      p<-p+geom_jitter()
    if (input$smooth)
      p<- p+geom_smooth(method = 'loess')
    
    plotly::ggplotly(p) %>% 
      layout(height = input$plotHeight, autosize=TRUE)})
  
  ## Filter data selected
  My_Uploaded_Data <- reactive({
    My_Uploaded_Data<-data.table(diamonds)
    My_Uploaded_Data
  })
  
  My_Filtered_Data <- reactive({
    My_Filtered_Data<-My_Uploaded_Data()
    My_Filtered_Data[cut %in% input$filter1]
  })
  
  My_Filtered_Data2 <- reactive({
    My_Filtered_Data2<-My_Filtered_Data()
    My_Filtered_Data2[clarity %in% input$filter2]
  })  
  
  My_Filtered_Data3 <- reactive({
    My_Filtered_Data3<-My_Filtered_Data2()
    My_Filtered_Data3[color %in% input$filter3]
  })  
  My_Filtered_Data4 <- reactive({
    My_Filtered_Data4<-My_Filtered_Data3()
    My_Filtered_Data4[carat >= input$filter4]
  }) 
  My_Filtered_Data5 <- reactive({
    My_Filtered_Data5<-My_Filtered_Data4()
    My_Filtered_Data5[price >= input$filter5]
  }) 
  
  output$mydata<-renderDataTable({
    My_Filtered_Data5()
  })
  
  output$Summarytext<- renderText({
    numOptions<-nrow(My_Filtered_Data5())
    if (is.null(numOptions)){
      numOptions <- 0
    }
    paste0("We Found ",numOptions," options for you")
  })
  
  output$plot<- renderPlot(
    {if (is.na(My_Filtered_Data5()))
    {return(NULL)}
      ggplot(My_Filtered_Data5(),aes(x=carat,y=price))+stat_bin2d(bins=10)+scale_fill_gradient(low="lightblue",high="red",limits=c(0,6000))
      
      
    }
  )
  
  
  output$x3 <- downloadHandler('filtered.csv', 
                               content = function(file) {
                                 s <- input$x1_rows_selected 
                                 if (length(s)) 
                                 {write.csv(My_Filtered_Data5(), file)} 
                                 else if (!length(s)) {write.csv(My_Filtered_Data5(), file)}})
})