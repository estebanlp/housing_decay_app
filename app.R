# Image classification app
# link to download the images: https://www.dropbox.com/t/qdIk8cmtLt2oyQuK
d <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(d)

library(shiny)
library(shinysurveys)


radioB_question <- data.frame(
  question = c("Is this house showing signs of roof damage?", "Is this house showing signs of roof damage?","Is this house showing signs of roof damage?",
               "Is this house showing signs of foundation defects?","Is this house showing signs of foundation defects?","Is this house showing signs of foundation defects?",
               "Is this house showing signs of exterior wall damage?","Is this house showing signs of exterior wall damage?","Is this house showing signs of exterior wall damage?"),
  option =  c("Yes","No","Not visible","Yes","No","Not visible","Yes","No","Not visible"),
  input_type = c("mc","mc","mc","mc","mc","mc","mc","mc","mc"),
  input_id = c("house_decay","house_decay","house_decay",
               "foundation_decay","foundation_decay","foundation_decay",
               "exterior_wall_decay","exterior_wall_decay","exterior_wall_decay"),
  dependence = NA,
  dependence_value = NA,
  required = c(TRUE,TRUE,TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
)

# radioB_question <- data.frame(
#   question = "Is this house showing sings of decay?",
#   option =  c("Yes","No","Not visible"),
#   input_type = "mc",
#   input_id = "house_decay",
#   dependence = NA,
#   dependence_value = NA,
#   required = TRUE
# )

#index creator
treated<-paste0(0:81,"/")
control<-paste0(0:81,"_n/")

control2<-NULL
for(a in 0:81){
  control2<-c(control2,paste0(control[a+1],dir(control[a+1]),"/"))
}
  
data<-data.frame(
  h_id=c(treated,control2),
  HD_d=NA, # missing please add (in comments in line 24)
  roof=NA,
  wds=NA, # missing please add
  walls=NA,
  foundation=NA,
  d1=NA, # missing please add as a matrix question
  d2=NA,
  d3=NA,
  d4=NA,
  d5=NA,
  d6=NA
)

#houses<-as.numeric(list.files("03_image_classification_app/housing_decay_images/"))
#houses<-houses[!is.na(houses)]

#i<-1

# Define UI for application 
ui <- fluidPage(
 
   titlePanel("San Antonio Housing Decay Project - UTSA-Planning"),
  
   actionButton(inputId = 'begin_session',label = "(Re)Start session"),  
   
   br(),
   actionButton(inputId = "next_image",label = "Get image"),
   #numericInput("image_id", "House ID:", 0),
   textOutput('counter'),
   hr(),
   fluidRow(
     column(4,
            h4("Side B"),
            imageOutput(outputId = "sideB")
      ),
     column(4,
            h4("Front View"),
            imageOutput(outputId = "frontview")
      ),
     column(4,
            h4("Side A"),
            imageOutput(outputId = "sideA")
     )),
  surveyOutput(df = radioB_question)
   
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

  
  
  image_id<-eventReactive(input$next_image, {
    dd<-data[is.na(data$HD_d),]
    sample(dd$h_id,size = 1)
    })  
  
  output$counter<-renderText({
    dd<-data[is.na(data$HD_d),]
    paste(dim(dd)[1],"reviewed out of",dim(data)[1])})
  
    output$sideA <- renderImage({
      
      file1<-normalizePath(file.path(paste0(image_id(),"sideA.jpg")),winslash = "/")
      return(list(
        src = file1,
        height ="100%"
      ))
    }, deleteFile = FALSE)
    
  
  
  #observeEvent(input$next_image, {
    output$frontview <- renderImage({
      
      file2<-normalizePath(file.path(paste0(image_id(),"target.jpg")))
      return(list(
        src = file2,
        height="100%"
      ))
      }, deleteFile = FALSE)
  #})
    #observeEvent(input$next_image, {
    output$sideB <- renderImage({
      
      file3<-normalizePath(file.path(paste0(image_id(),"sideB.jpg")))
      return(list(
        src = file3,
        height="100%"
      ))
    }, deleteFile = FALSE)
    
  #})
  
  renderSurvey()
  
  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Thank you, click NEXT to see the next house"
    ))
  })
  
  observeEvent(input$submit, {
    responses<- getSurveyData()[,4]
    write.table(x =as.character(paste(input$image_id,responses,sep = ",")),file = "test.csv",append=T)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
