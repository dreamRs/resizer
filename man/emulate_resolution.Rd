% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/emulate_resolution.R
\name{emulate_resolution}
\alias{emulate_resolution}
\title{View a Shiny app with different resolution}
\usage{
emulate_resolution(
  appDir = NULL,
  urls = NULL,
  width = 800,
  height = 600,
  controls = TRUE,
  host = getOption("shiny.host", "127.0.0.1"),
  port = getOption("shiny.port")
)
}
\arguments{
\item{appDir}{The application to run, same as in \code{\link[shiny]{runApp}}.}

\item{urls}{A vector with URLs to simulate resolution.}

\item{width}{Original width for the iframe containing the application.}

\item{height}{Original height for the iframe containing the application.}

\item{controls}{Display controls widgets to manipulate width/height, URL. Default to \code{TRUE}.}

\item{host}{The TCP port that the application should listen on. See \code{\link[shiny]{runApp}}.}

\item{port}{The IPv4 address that the application should listen on. See \code{\link[shiny]{runApp}}.}
}
\description{
When developing applications, the display may
 be different depending on the screen on which the application
 is displayed. This application allows you to simulate different
 resolutions to verify that the display is correct.
}
\examples{
if (interactive()) {
  library(shiny)
  library(resizer)
  
  # From app directory :
  emulate_resolution(
    system.file("examples", "01_hello", package = "shiny")
  )
  
  
  # From shiny obj
  ui <- fluidPage(
    tags$h1("My application")
  )
  server <- function(input, output, session) {
    
  }
  
  emulate_resolution(
    shinyApp(ui, server)
  )
}
}
