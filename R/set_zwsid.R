#' Set access token (Zillow Web Service ID)
#'
#' @param id Zillow Web Service ID
#'
set_zwsid <- function(id) {
  options('ZWSID' = id)
  return(invisible())
}
