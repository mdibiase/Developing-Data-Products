library(memisc);data("UCBAdmissions")
df <- to.data.frame(UCBAdmissions)
glm1 <- glm(cbind(Admitted,Rejected)~., data=df, family=binomial())

chances <- function(gend, dept){
  newdata <- data.frame(Gender = gend, Dept = dept)
  predict(glm1, newdata, type = "response")
}


shinyServer(
  function(input, output){
    output$ogend <- renderPrint({input$gend})
    output$odept <- renderPrint({input$dept})
    output$prediction <- renderPrint({chances(input$gend, input$dept)})
  }
)