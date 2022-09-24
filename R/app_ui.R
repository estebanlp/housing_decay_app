#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom shinysurveys surveyOutput
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel("San Antonio Housing Decay Project - UTSA-Planning"),
      actionButton(inputId = "begin_session", label = "(Re)Start session"),
      br(),
      actionButton(inputId = "next_image", label = "Get image"),
      # numericInput("image_id", "House ID:", 0),
      textOutput("counter"),
      hr(),
      fluidRow(
        column(
          4,
          h4("Side B"),
          imageOutput(outputId = "sideB")
        ),
        column(
          4,
          h4("Front View"),
          imageOutput(outputId = "frontview")
        ),
        column(
          4,
          h4("Side A"),
          imageOutput(outputId = "sideA")
        )
      ),
      surveyOutput(df = housingdecay::radioB_question)
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "housingdecay"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
