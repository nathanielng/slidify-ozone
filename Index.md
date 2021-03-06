---
title       : Ozone Level Predictor
subtitle    : A Shiny app for estimating ozone levels based on the airquality dataset
author      : Nathaniel
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

<style>
.title-slide {
  background-color: purple; /* FFAFFF */
}
.title-slide hgroup > h1,
.title-slide hgroup > h2 {
  color: white;
}
.title-slide hgroup > p {
  color: white;
}
</style>

## What is inside the Airquality Dataset?

### New York Air Quality Measurements

##### Description

Daily air quality measurements in New York, May to September 1973.

##### Format

A data frame with 154 observations on 6 variables.

```
[,1]	Ozone	numeric	Ozone (ppb)
[,2]	Solar.R	numeric	Solar R (lang)
[,3]	Wind	numeric	Wind (mph)
[,4]	Temp	numeric	Temperature (degrees F)
[,5]	Month	numeric	Month (1--12)
[,6]	Day	numeric	Day of month (1--31)
```

##### Information is accessible via


```r
library(datasets); data(airquality); help(airquality)
```

##### Original reference

Chambers, J. M., Cleveland, W. S., Kleiner, B. and Tukey, P. A. (1983) Graphical Methods for Data Analysis. Belmont, CA: Wadsworth.

--- .class #id 

## Can Ozone Levels Be Predicted From This Dataset?

It is not too difficult to show that ozone levels are correlated with both temperature and wind:

```r
df <- airquality; df <- df[!is.na(df$Ozone),]; df <- df[!is.na(df$Solar.R),]
model_full <- lm(Ozone ~ ., data=df)
s.df <- as.data.frame(summary(model_full)$coef)
s.df[order(s.df$Pr), ]
```

```
##                 Estimate Std. Error   t value     Pr(>|t|)
## Temp          1.89578642  0.2738869  6.921786 3.657729e-10
## Wind         -3.31844386  0.6445095 -5.148789 1.231276e-06
## (Intercept) -64.11632110 23.4824887 -2.730389 7.420531e-03
## Solar.R       0.05027432  0.0234186  2.146768 3.411381e-02
## Month        -3.03995664  1.5134568 -2.008618 4.714471e-02
## Day           0.27387752  0.2296708  1.192479 2.357615e-01
```



In this model, the p-value for `temperature` is in the order of 10\^-10 and the p-value for `wind` is in the order of 10\^-6.

--- .class #id 

## Accuracy of a simple GLM model

The dataset is partitioned into training sets (70%) and a testing set (30%). The accuracy of the model is then evaluated (as a root mean squared error) against the testing set:

```r
library(caret); set.seed(12378)
inTrain <- createDataPartition(y=df$Ozone, p=0.7, list=FALSE)
training <- df[ inTrain,]
testing  <- df[-inTrain,]
fitGLM <- train(Ozone ~ Temp+Wind, data=training, method="glm") 
predGLM <- predict(fitGLM, newdata=testing)
(errGLM <- sqrt(mean((predGLM-testing$Ozone)^2)))
```

```
## [1] 18.55981
```
Based on this model, the root mean squared error for the ozone level (in ppb) is given by: `errGLM =` 18.56.  For comparison, the minimum value of ozone in the airquality dataset is 1 and the maximum value is 168 (excluding NA values).

---

## Conclusion

Finally, to use the ozone predictor app, simply key in a temperature and wind speed in the left panel, as shown:

<div style='text-align: center;'>
    <img height='500' src='ozone.png' />
</div>
