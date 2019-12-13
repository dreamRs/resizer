

#' Open a browser to get screen resolution
#'
#' @export
#'
#' @importFrom utils browseURL
#'
#' @examples
#' if (interactive()) {
#' 
#' screen_size()
#' 
#' }
screen_size <- function() {
  browseURL(url = system.file("www/screenSize.html", package = "resizer"))
}


