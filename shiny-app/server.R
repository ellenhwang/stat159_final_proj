library(shiny)
source("./setup.R")

shinyServer(function(input, output) {
  output$scatterplot <- renderPlot({
    repay=clean_data$RPY_3YR_RT
    inputvar=input$variable
    xvar=clean_data[,inputvar]
    ggplot(clean_data, aes_string(x = input$variable, y = "RPY_3YR_RT")) + geom_point() + geom_smooth() +
      ggtitle(paste('Scatter Plot of 3 Yr Repayment Rate vs', ColToNameMap[input$variable])) +
      labs(y = '3 Yr Repayment Rate', x = ColToNameMap[input$variable])
  })
  output$hist01 <- renderPlot({
    ggplot(clean_data[clean_data[input$breakdown] == 1, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle(SplitToNamesMap[paste(input$breakdown, "1")]) + labs(x = '3 Yr Repayment Rate')
  })
  output$hist02 <- renderPlot({
    ggplot(clean_data[clean_data[input$breakdown] == 2, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle(SplitToNamesMap[paste(input$breakdown, "2")]) + labs(x = '3 Yr Repayment Rate')
  })
  output$hist03 <- renderPlot({
    ggplot(clean_data[clean_data[input$breakdown] == 3, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle(SplitToNamesMap[paste(input$breakdown, "3")]) + labs(x = '3 Yr Repayment Rate')
  })
  is_region <- reactive({if(input$breakdown=="region"){TRUE}else{FALSE}})
  output$hist04 <- renderPlot({
    if(is_region()){ggplot(clean_data[clean_data[input$breakdown] == 4, ], aes(x = RPY_3YR_RT)) + geom_histogram(aes(y = ..density.., fill = ..density..)) + geom_density() + ggtitle(SplitToNamesMap[paste(input$breakdown, "4")]) + labs(x = '3 Yr Repayment Rate')}
  })
})