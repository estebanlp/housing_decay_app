jsResetCode <- "shinyjs.reset = function() {history.go(0)}"

#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinysurveys renderSurvey getSurveyData
#' @importFrom utils write.table
#' @importFrom purrr map_df
#' @importFrom dplyr tibble bind_rows left_join select
#' @importFrom rlang sym
#' @importFrom tidyr pivot_wider
#' @importFrom readr read_csv write_csv cols col_character
#' @noRd
app_server <- function(input, output, session) {
  dout <- "~/housingdecay_output/"
  try(dir.create(dout))

  inp <- list.files(dout, full.names = TRUE)
  if (length(inp) > 0L) {
    answers <- map_df(
      inp,
      function(x) {
        read_csv(x, col_types = cols(image = col_character()))
      }
    )
  } else {
    answers <- tibble(
      image = NULL,
      q1 = NULL,
      q2 = NULL,
      q3 = NULL,
      q4 = NULL,
      q5 = NULL,
      q6a = NULL,
      q6b = NULL,
      q6c = NULL,
      q6d = NULL,
      q6e = NULL,
      q6f = NULL,
      responses = NULL
    )
  }

  dd <- housingdecay::ds[is.na(housingdecay::ds$HD_d), ]
  dd$image <- gsub("images|/", "", dd$h_id)
  dd <- dd[!dd$image %in% unique(answers$image), ]

  image_id <- eventReactive(input$next_image, {
    sample(dd$h_id, size = 1)
  })

  output$counter <- renderText({
    paste(nrow(dd), "reviewed out of", nrow(housingdecay::ds))
  })

  output$sideA <- renderImage(
    {
      file1 <- system.file(paste0("app/", image_id()), "sideA.jpg", package = "housingdecay")
      print(paste(image_id(), file1, sep = " - "))
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

  # observeEvent(input$submit, {
  #   showModal(modalDialog(
  #     title = "Thank you, click NEXT to see the next house"
  #   ))
  # })

  observeEvent(input$submit, {
    responses <- getSurveyData() %>%
      select(!!sym("question_id"), !!sym("response"))

    responses <- left_join(housingdecay::allresponses, responses)

    # saveRDS(responses, "~/github/housing_decay_app/responses.rds")
    # write.table(x = as.character(paste(input$image_id, responses, sep = ",")), file = "test.csv", append = T)
    # print(as.character(input$image_id))

    # responses <- as.character(responses)
    # for (i in seq_along(responses)) {
    #   responses[i] <- ifelse(is.null(responses[i]), NA, responses[i])
    # }
    # print(responses)

    out <- tibble(
        image = gsub("images", "", gsub(".*/images|/", "", as.character(image_id()))),
        question = c(paste0("q", 1:5), paste0("q6", letters[1:6])),
        responses = responses$response
      )

    out$responses <- ifelse(out$responses == "", NA, out$responses)
    print(out)

    incomplete <- any(is.na(out$responses))

    if (isTRUE(incomplete)) {
      return(
        showModal(modalDialog(
          title = "Error",
          "Complete all the questions",
          easyClose = TRUE
        ))
      )
    }

    out <- pivot_wider(out, names_from = "question", values_from = "responses")

    # answers <- bind_rows(answers, out)
    # print(answers)

    fout <- gsub("_n", "n", gsub("/", "", paste0(gsub("images/", "", image_id()), "_", gsub("\\s+|:", "_", Sys.time()), ".csv")))
    # print(fout)
    write_csv(out, file = paste0(dout, fout))
    session$reload()
  })
}
