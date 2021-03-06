#' @title View a Shiny app with different resolution
#'
#' @description When developing applications, the display may
#'  be different depending on the screen on which the application
#'  is displayed. This application allows you to simulate different
#'  resolutions to verify that the display is correct.
#'
#' @param appDir The application to run, same as in \code{\link[shiny]{runApp}}.
#' @param urls A vector with URLs to simulate resolution.
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
#' 
#' @examples 
#' if (interactive()) {
#'   library(shiny)
#'   library(resizer)
#'   
#'   # From app directory :
#'   emulate_resolution(
#'     system.file("examples", "01_hello", package = "shiny")
#'   )
#'   
#'   
#'   # From shiny obj
#'   ui <- fluidPage(
#'     tags$h1("My application")
#'   )
#'   server <- function(input, output, session) {
#'     
#'   }
#'   
#'   emulate_resolution(
#'     shinyApp(ui, server)
#'   )
#' }
emulate_resolution <- function(appDir = NULL, 
                               urls = NULL,
                               width = 800,
                               height = 600,
                               controls = TRUE,
                               host = getOption("shiny.host", "127.0.0.1"),
                               port = getOption("shiny.port")) {

  if (!is.null(urls) && !is.list(urls)) {
    urls <- setNames(as.list(urls), urls)
  }

  if (!is.null(appDir)) {
    if (is.null(port)) {
      ports <- 3000:8000
      ports <- ports[!ports %in% c(3659, 4045, 6000, 6665:6669, 6697)]
      port <- sample(x = ports, size = 1)
    }
    url_app <- paste0("http://", host, ":", port)
    on.exit({
      Sys.sleep(0.5)
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
  if (!is.null(appDir))
    print(widget)
  widget
}


#' @importFrom htmltools tags attachDependencies tagAppendAttributes HTML
#' @importFrom shinyWidgets searchInput
#' @importFrom shiny icon actionLink fluidRow column selectInput actionButton checkboxInput
#' @importFrom rmarkdown html_dependency_bootstrap html_dependency_jquery html_dependency_font_awesome
resizer_html <- function(id, style, class, ...) {
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
              slider_input(
                inputId = "iframe_width",
                label = "Width:",
                min = 100, 
                max = 1600, 
                value = 800,
                post = "px"
              )
            ),
            column(
              width = 6,
              slider_input(
                inputId = "iframe_height",
                label = "Height:",
                min = 100, 
                max = 1200, 
                value = 600, 
                post = "px"
              )
            )
          ),
          tags$span("Shortcuts:"),
          # actionLink(inputId = "width800_height600", label = "800x600"),
          # actionLink(inputId = "width1024_height768", label = "1024x768"),
          shortcut_resolution(360, 640),
          shortcut_resolution(800, 600),
          shortcut_resolution(1024, 768),
          shortcut_resolution(1920, 1080),
          tags$div(
            style = "display: inline-block",
            class = "pull-right",
            actionButton(
              inputId = "refresh", 
              label = "refresh",
              icon = icon("refresh"),
              class = "btn-xs"
            ),
            tagAppendAttributes(
              checkboxInput(
                inputId = "autorefresh",
                label = HTML("&nbsp;auto-refresh?"),
                value = TRUE
              ),
              style = "display: inline-block;"
            )
          )
        ),
        tags$br(),
        tags$div(
          class = "container",
          style = "max-width: 800px; margin: auto; padding: 0;",
          tags$iframe(
            id = id, class = class,
            # width = 800, height = 600,
            style = "border: 3px solid #006cfa;",
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

#' @importFrom shiny sliderInput
#' @importFrom htmltools tagAppendAttributes
slider_input <- function(...) {
  slider <- sliderInput(...)
  slider <- suppress_dependencies(slider)
  slider$children[[2]]$attribs[["data-skin"]] <- NULL
  slider$children[[2]] <- tagAppendAttributes(
    slider$children[[2]],
    "data-skin" = "round"
  )
  slider
}

#' @importFrom htmltools tags
shortcut_resolution <- function(width, height) {
  tags$a(
    class = "action-button shortcut-resolution",
    href = "#",
    paste(width, height, sep = "x"),
    `data-width` = width,
    `data-height` = height
  )
}


resizer_raw_html <- function(id, style, class, ...) {
  attachDependencies(
    x = tags$div(
      class = "container",
      style = "max-width: 800px; margin: auto; padding: 0; margin-top: 15px;",
      tags$iframe(
        id = id, class = class,
        style = "border: 3px solid #006cfa;",
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
