---
title       : Developing Data Products Presentation
subtitle    : Odds of Admission to UCB
author      : Mike
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Introduction

My Shiny App calculates the chances of admission to UCB's 6 largest graduate programs based on the applicant's Gender and the Department they are applying to. It uses the historical data from the UCBAdmissions dataset in the R "datasets" package. The data is from the 1973 academic year. 

This presentation will show the methodology and code used to generate the predictions in the Shiny app.

This link was a helpful resource in figuring out how to run the `glm()` function with the `cbind()` as the response.

http://www.isid.ac.in/~deepayan/LM2010/quiz2sol.pdf

And here is a link to the "memisc" package that saved a bunch of steps when I was trying to get the data into a workable form: 

http://www.inside-r.org/packages/cran/memisc/docs/to.data.frame

--- .class #id 

## Loading The Data

First, let's load the packages and data required to do the analysis. 


```r
library(memisc);data("UCBAdmissions")
class(UCBAdmissions)
```

```
## [1] "table"
```

The UCBAdmissions data set is a 3D array of class "table". To perform the Generalized Linear Regression, we'll need to convert it to a data frame. The  `to.data.frame()` function in the "memisc" package let's us do just that. 

---

## Prepping the Data

Below, I use the `to.data.frame()` function to create the "tidy" data set I'll use to run the regression analysis. 


```r
df <- to.data.frame(UCBAdmissions)
head(df,4)
```

```
##   Gender Dept Admitted Rejected
## 1   Male    A      512      313
## 2 Female    A       89       19
## 3   Male    B      353      207
## 4 Female    B       17        8
```

```r
dim(df)
```

```
## [1] 12  4
```

--- 

## The Model

Due to the fact that our "response" is in 2 different columns, we need to  `cbind()` them together in the call to  `glm()`. 


```r
glm1 <- glm(cbind(Admitted,Rejected)~., data=df, family=binomial())

summary(glm1)$coef
```

```
##                 Estimate Std. Error     z value     Pr(>|z|)
## (Intercept)   0.58205140 0.06899260   8.4364326 3.271701e-17
## GenderFemale  0.09987009 0.08084647   1.2353055 2.167168e-01
## DeptB        -0.04339793 0.10983890  -0.3951053 6.927652e-01
## DeptC        -1.26259802 0.10663289 -11.8406063 2.407065e-32
## DeptD        -1.29460647 0.10582342 -12.2336476 2.054991e-34
## DeptE        -1.73930574 0.12611350 -13.7915909 2.863743e-43
## DeptF        -3.30648006 0.16998181 -19.4519642 2.804785e-84
```

---

## Getting a Probability

To make a prediction, we'll just need a dataframe with the new applicants Gender and Department. 


```r
newdata <- data.frame(Gender = "Female", Dept = "D")
predict(glm1, newdata, type = "response")
```

```
##        1 
## 0.351447
```

Using  `type = "response"` converts the output to a probability. 

The Shiny app uses two drop down menus to let the user input the Gender ("Male" or "Female") and Dept variables ("A"-"F"). The `server.R` file then runs the exact same code as above to get the prediction for the specific combination of Gender and Dept. 



