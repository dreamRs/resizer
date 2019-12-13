#' @title View a Shiny app with different resolution
#'
#' @description When developing applications, the display may
#'  be different depending on the screen on which the application
#'  is displayed. This application allows you to simulate different
#'  resolutions to verify that the display is correct.
#'
#' @param appDir The application to run, same as in \code{\link[shiny]{runApp}}.
#' @param urls A vector with URLs to test.
#' @param width Original width for the iframe containing the application.
#' @param height Original height for the iframe containing the application.
#' @param controls Display controls widgets to manipulate width/height, URL. Default to \code{TRUE}.
#' @param host The TCP port that the application should listen on. See \code{\link[shiny]{runApp}}.
#' @param port The IPv4 address that the application should listen on. See \code{\link[shiny]{runApp}}.
#'
#'
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @importFrom stats setNames
#' @importFrom shiny runApp
#'
#' @export
emulate_resolution <- function(appDir = NULL, urls = NULL,
                               width = 800, height = 600,
                               controls = TRUE,
                               host = getOption("shiny.host", "127.0.0.1"),
                               port = getOption("shiny.port")) {

  if (!is.null(urls) && !is.list(urls)) {
    urls <- setNames(as.list(urls), urls)
    urls <- c(list("None" = "none"), urls)
  }

  if (!is.null(appDir)) {
    if (is.null(port)) {
      ports <- 3000:8000
      ports <- ports[!ports %in% c(3659, 4045, 6000, 6665:6669, 6697)]
      port <- sample(x = ports, size = 1)
    }
    url_app <- paste0("http://", host, ":", port)
    on.exit({
      runApp(appDir = appDir, port = port, host = host, launch.browser = FALSE)
    })
  } else {
    url_app <- NULL
  }

  x <- list(
    url_app = url_app,
    urls = urls,
    width = width,
    height = height,
    controls = controls
  )

  widget <- createWidget(
    name = ifelse(isTRUE(controls), "resizer", "resizer_raw"),
    x = x,
    width = NULL,
    height = NULL,
    package = "resizer",
    elementId = NULL,
    sizingPolicy = sizingPolicy(
      defaultWidth = "100%",
      defaultHeight = "100%",
      viewer.defaultHeight = "100%",
      viewer.defaultWidth = "100%",
      knitr.figure = FALSE,
      browser.fill = FALSE,
      viewer.suppress = TRUE,
      browser.external = TRUE,
      padding = 0
    )
  )
  print(widget)
  widget
}


#' @importFrom htmltools tags attachDependencies
#' @importFrom shinyWidgets searchInput
#' @importFrom shiny icon sliderInput actionLink fluidRow column selectInput
#' @importFrom rmarkdown html_dependency_bootstrap html_dependency_jquery html_dependency_font_awesome
resizer_html <- function(id, style, class, ...) {
  slider_width <- sliderInput(
    inputId = "iframe_width", label = "Width:",
    min = 100, max = 1600, value = 800, post = "px"
  )
  slider_height <- sliderInput(
    inputId = "iframe_height", label = "Height:",
    min = 100, max = 1200, value = 600, post = "px"
  )
  text_url <- searchInput(
    inputId = "screen_url",
    label = "Enter an URL:",
    btnSearch = icon("search"),
    btnReset = icon("remove")
  )
  attachDependencies(
    x = tags$div(
      # tags$div(id = "particles", style = "position:fixed; bottom:0; right:0; left:0; top:0;"),
      tags$div(
        tags$div(
          style = "max-width: 800px; margin: auto;",
          tags$h4(tags$b("Shiny screen simulator")),
          fluidRow(
            column(
              width = 6,
              suppress_dependencies(text_url)
            ),
            column(
              width = 6,
              selectInput(
                inputId = "list_urls", label = "URLs:",
                choices = NULL, selectize = FALSE
              )
            )
          ),
          fluidRow(
            column(
              width = 6,
              suppress_dependencies(slider_width)
            ),
            column(
              width = 6,
              suppress_dependencies(slider_height)
            )
          ),
          tags$span("Shortcuts:"),
          actionLink(inputId = "width800_height600", label = "800x600"),
          actionLink(inputId = "width1024_height768", label = "1024x768")
        ),
        tags$div(
          class = "container",
          style = "max-width: 800px; margin: auto; padding: 0;",
          tags$iframe(
            id = id, class = class,
            # width = 800, height = 600,
            style = "border: 5px inset steelblue;",
            src = "http://127.0.0.1"
          )
        )
      )
    ),
    value = list(
      html_dependency_jquery(),
      html_dependency_bootstrap("default"),
      html_dependency_font_awesome()
    )
  )
}

resizer_raw_html <- function(id, style, class, ...) {
  attachDependencies(
    x = tags$div(
      class = "container",
      style = "max-width: 800px; margin: auto; padding: 0;",
      tags$iframe(
        id = id, class = class,
        style = "border: 5px inset steelblue;",
        src = "http://127.0.0.1"
      )
    ),
    value = html_dependency_jquery()
  )
}


#' @importFrom htmltools htmlDependencies htmlDependencies<-
suppress_dependencies <- function(tag) {
  htmlDependencies(tag) <- NULL
  tag
}
