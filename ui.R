#How to run this application:
#setwd()  #to the folder containing ui.R and server.R
#library(shiny)
#runApp() #or runApp(path_to_this_folder)

library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Ozone predictor based on the airquality dataset"),
  sidebarPanel(
    h3('Enter data here'),
    p('Enter the temperature and the wind speed to get a prediction on ozone levels'),
    numericInput('itemp', 'Temperature (Farenheit)', value = 80, min = 50, max = 100, step = 1),
    sliderInput('iwind','Wind Speed (mph)', 12, min=0, max = 21, step = 1),
    #checkboxGroupInput("iview", "View Options",
    #                   c("Temperature" = "temp",
    #                     "Wind"  = "wind",
    #                     "Solar" = "solar")),
    #dateInput("date", "Date:")
    p('Based on the input temperature and wind speed, this application uses a GLM predictor to estimate the ozone level. Plots for ozone vs temperature and wind are shown on the right. Regressions lines in the plots show predictions when only a single predictor is used (i.e. Ozone ~ Temperature or Ozone ~ Wind). The red lines in the plots correspond to the temperature and wind speed values in this side panel.')
  ),
  mainPanel(
    h4('Prediction on Ozone level (ppb):'),
    verbatimTextOutput("oprediction"),
    h4('Model Used'),
    code('fit <- lm(Ozone ~ Temp + Wind, data=airquality)'),
    p(' '),
    plotOutput('myPlot'),
    h4('Calculation Used'),
    code('coef.intercept <- fit$finalModel$coefficients[["(Intercept)"]]'),p(' '),
    code('coef.temp      <- fit$finalModel$coefficients[["Temperature"]]'),p(' '),
    code('coef.wind      <- fit$finalModel$coefficients[["Wind"]]'),p(' '),
    code('ozone <- coef.intercept + coef.temp * temperature + coef.wind * wind')
  )
))
