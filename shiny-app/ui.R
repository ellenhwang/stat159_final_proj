library(shiny)
source("./setup.R")

shinyUI(fluidPage(
  titlePanel("College Loan Repayment Rates: Predictors and Factors"),
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
      tabPanel("Plots", plotOutput("scatterplot")), 
      tabPanel("Histograms", 
               fluidRow(
                 splitLayout(cellWidths = c("33%", "33%", "33%", "33%"), 
                             plotOutput("hist01"), plotOutput("hist02"), plotOutput("hist03"), plotOutput("hist04"))
               )
      )
    )
  )
))