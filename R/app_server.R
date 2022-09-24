#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinysurveys renderSurvey getSurveyData
#' @importFrom utils write.table
#' @importFrom purrr map
#' @noRd
app_server <- function(input, output, session) {
  dout <- "~/housingdecay_output/"
  try(dir.create(dout))

  inp <- list.files(dout, full.names = TRUE)
  if (length(inp) > 0L) {
    answers <- readRDS(inp[inp == max(inp)])
  } else {
    answers <- data.frame(
      image = NULL,
      question = NULL,
      responses = NULL
    )
  }

  image_id <- eventReactive(input$next_image, {
    dd <- housingdecay::ds[is.na(housingdecay::ds$HD_d), ]
    dd$image <- gsub("images|/", "", dd$h_id)
    dd <- dd[!dd$image %in% unique(answers$image), ]
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
    # write.table(x = as.character(paste(input$image_id, responses, sep = ",")), file = "test.csv", append = T)
    # print(as.character(input$image_id))
    out <- data.frame(
        image = gsub("images", "", gsub(".*/images|/", "", as.character(image_id()))),
        question = paste0("Q", 1:5),
        responses = responses
      )
    answers <- rbind(answers, out)
    saveRDS(answers, file = paste0(dout, gsub("\\s+|:", "_", Sys.time()), ".rds"))
    inp <- list.files(dout, full.names = TRUE)
    map(inp[inp != max(inp)], file.remove)
  })
}
