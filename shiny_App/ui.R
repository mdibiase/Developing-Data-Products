data("UCBAdmissions");library(memisc)

shinyUI(
  pageWithSidebar(
    headerPanel("UCB Admissions Chances"),
    
    sidebarPanel(
      h1("A Little About You..."),
      h4("Select Your Gender"),
      selectInput(inputId = "gend", label = "Gender", choices = 
                    c("Male"="Male",
                      "Female"= "Female")),
      h4("To Which Department Are You Applying?"),
      selectInput(inputId = "dept", label = "Department", choices = 
                    c("A"= "A", "B"="B", "C"="C",
                      "D"= "D", "E"="E", "F"="F")),
      submitButton("Submit")
    ),
    mainPanel(
      h1("Output"),
      p("The chances are calculated using a Generalized Linear Model to predict your odds of admission
        given your gender and the department you are applying to. The model was built using the historical
        data in the UCBAdmissions dataset. All the data points were used in building the model and no attempt to split the data into
        training and test sets was made."),
      h3("You Entered"),
      verbatimTextOutput("ogend"),
      verbatimTextOutput("odept"),
      h2("Your Chances of Admission Are:"),
      verbatimTextOutput("prediction")
    )
  )
)