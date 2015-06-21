library(datasets)
data(airquality)
library(ggplot2)
library(gridExtra)

#Clean the Data
df <- airquality
names(df)[4] <- "Temperature"
df$date <- ISOdate(1973,df$Month,df$Day)
df$wday <- as.POSIXlt(df$date)$wday
wday <- c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")
df$wday <- factor(wday[df$wday+1])
df$iswknd <- factor(df$wday=="Sat" | df$wday=="Sun")
df <- df[!is.na(df$Ozone),]   #Remove rows where Ozone=NA
df <- df[!is.na(df$Solar.R),] #Remove rows where Solar.R=NA

library(caret)
set.seed(12378)
inTrain <- createDataPartition(y=df$Ozone, p=0.7, list=FALSE)
training <- df[ inTrain,]
testing  <- df[-inTrain,]

fitGLM1 <- train(Ozone ~ Temperature+Wind, data=training, method="glm") #17.4857
#predGLM1 <- predict(fitGLM1, newdata=testing)
#errGLM1 <- sqrt(mean((predGLM1-testing$Ozone)^2))
fit.intercept <- fitGLM1$finalModel$coefficients[["(Intercept)"]] #[1] -51.90363
fit.temp <- fitGLM1$finalModel$coefficients[["Temperature"]] #[1] 1.711051
fit.wind <- fitGLM1$finalModel$coefficients[["Wind"]] #[1] -3.798366

#fitRF1 <- train(Ozone ~ Temp+Wind+Solar.R, data=training, method="rf", prox=TRUE) #13.7733
#predRF1 <- predict(fitRF1, newdata=testing)
#errRF1 <- sqrt(mean((predRF1-testing$Ozone)^2))

#fitRPART1 <- train(Ozone ~ Temp+Wind+Solar.R, data=training, preProcess=c("center","scale"), method="rpart") #20.3746
#predRPART1 <- predict(fitRPART1, newdata=testing)
#errRPART1 <- sqrt(mean((predRPART1-testing$Ozone)^2))

shinyServer(
  function(input, output) {
    output$myPlot <- renderPlot({
      temperature <- input$itemp
      wind <- input$iwind
      g1 <- ggplot(df, aes(Temperature, Ozone)) + geom_point(size=5,alpha=1/2) + geom_smooth(method="lm")
      g1 <- g1 + labs(y = "Ozone (ppb)") + ylim(0,170) + geom_vline(xintercept=temperature, width=5, colour="red")
      g2 <- ggplot(df, aes(Wind, Ozone)) + geom_point(size=5,alpha=1/2) + geom_smooth(method="lm")
      g2 <- g2 + labs(y = "") + ylim(0,170) + geom_vline(xintercept=wind, width=5, colour="red")
      #g3 <- ggplot(df, aes(Solar.R, Ozone)) + geom_point(size=5,alpha=1/2) + geom_smooth(method="lm")
      #g3 <- g3 + labs(y = "") + ylim(0,170) + geom_vline(xintercept=input$isolar, width=5, colour="red")
      grid.arrange(g1, g2, ncol = 2, main = "Air Quality Measurements (NY)") #nrow = 3
    })
    output$odate<- renderPrint({input$date})
    pred <- reactive({
      #pred  <- predict(fitGLM1, newdata=data.frame(Temperature = input$itemp, Wind = input$iwind))
      fit.intercept + fit.temp * as.numeric(input$itemp) + fit.wind * as.numeric(input$iwind)
    })
    output$oprediction <- renderPrint({pred()})
  }
)