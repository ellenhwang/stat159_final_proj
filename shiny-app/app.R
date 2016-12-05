library("shiny")
library(ggplot2)
library(gridExtra)

clean_data <- read.csv('../data/cleaned_data/clean_data.csv')

# Quick Barplot Aggregated Mean Function
agg_grp <- function(columns, fun) {
  a <- clean_data[, columns]
  a <- na.omit(a)
  b <- aggregate(a[, columns[1]], by = list(as.factor(a[,columns[2]])), fun) # Region 0 not included bc 1 obs
  ggplot(b, aes(x = factor(Group.1), y = x)) + geom_bar(stat = "identity")+geom_text(aes(label = round(x,2)), vjust = 3, size = 5) +
    ggtitle(paste("Barplot of Mean", columns[1], "on", columns[2], "Levels")) + xlab(columns[2]) + ylab(columns[1])
}

clean_data$l10tuit <- log10(clean_data$TUITFTE)
clean_data$degtype <- sapply(5 - clean_data$HIGHDEG, FUN=function(x){min(3, x)})
clean_data$region <- sapply(clean_data$REGION / 2, FUN=ceiling)

ColToNameMap <- c("log10(Tuition)", "Completion Rate", "Average Net Price")
names(ColToNameMap) <- c("l10tuit", "C100_4", "NPT4_PUB")

SplitToNamesMap <- c('3 Yr Rates for Public Schools', 'For Private-NonProfit Schools', 'For Private-ForProfit Schools',
    '3 Yr Rates for Four-Year Degrees', 'For Two-Year Degrees', 'For Less-Than-Two-Year Degrees',
    'Schools granting graduate degrees', 'Granting only 4-year degrees', 'Granting only 2-year degrees',
    "Schools in the Northeast", "In the Midwest", "In the South", "In theWest")
names(SplitToNamesMap) <- c("CONTROL 1", "CONTROL 2", "CONTROL 3",
                            "ICLEVEL 1", "ICLEVEL 2", "ICLEVEL 3",
                            "degtype 1", "degtype 2", "degtype 3",
                            "region 1", "region 2", "region 3", "region 4")

ui <- fluidPage(
  titlePanel("3-year Repayment Rates: Predictors and Factors"),
  wellPanel(
  selectInput("variable", "Plot Variables against Repayment Rate",
              c("Completion Rate" = "C100_4",
                "Average Net Price" = "NPT4_PUB",
                "Tuition" = "l10tuit"
                )),
  selectInput("breakdown", "Plot Histograms of Repayment Rate by factor",
              c("Public vs. Private" = "CONTROL",
                "2 years vs. 4 years" = "ICLEVEL",
                "Highest Degree Offered" = "degtype",
                "Geographic Region" = "region"
              ))
  ),
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("scatterplot")), 
      tabPanel("Histogram", 
        fluidRow(
          splitLayout(cellWidths = c("33%", "33%", "33%", "33%"), 
                      plotOutput("hist01"), plotOutput("hist02"), plotOutput("hist03"), plotOutput("hist04"))
        )
      )
    )
  )
)

server <- function(input, output) {
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
}

shinyApp(ui, server)