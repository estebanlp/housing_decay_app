#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinysurveys renderSurvey getSurveyData
#' @importFrom utils write.table
#' @noRd
app_server <- function(input, output, session) {
  image_id <- eventReactive(input$next_image, {
    dd <- housingdecay::ds[is.na(housingdecay::ds$HD_d), ]
    sample(dd$h_id, size = 1)
  })

  output$counter <- renderText({
    dd <- housingdecay::ds[is.na(housingdecay::ds$HD_d), ]
    paste(dim(dd)[1], "reviewed out of", dim(housingdecay::ds)[1])
  })

  output$sideA <- renderImage(
    {
      file1 <- system.file(paste0("app/", image_id()), "sideA.jpg", package = "housingdecay")
      print(file1)
      return(list(
        src = file1,
        height = "100%"
      ))
    },
    deleteFile = FALSE
  )



  # observeEvent(input$next_image, {
  output$frontview <- renderImage(
    {
      file2 <- system.file(paste0("app/", image_id()), "target.jpg", package = "housingdecay")
      return(list(
        src = file2,
        height = "100%"
      ))
    },
    deleteFile = FALSE
  )
  # })
  # observeEvent(input$next_image, {
  output$sideB <- renderImage(
    {
      file3 <- system.file(paste0("app/", image_id()), "sideB.jpg", package = "housingdecay")
      return(list(
        src = file3,
        height = "100%"
      ))
    },
    deleteFile = FALSE
  )

  # })

  renderSurvey()

  observeEvent(input$submit, {
    showModal(modalDialog(
      title = "Thank you, click NEXT to see the next house"
    ))
  })

  observeEvent(input$submit, {
    responses <- getSurveyData()[, 4]
    write.table(x = as.character(paste(input$image_id, responses, sep = ",")), file = "test.csv", append = T)
  })
}
