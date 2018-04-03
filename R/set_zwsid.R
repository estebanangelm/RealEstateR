#' Set access token (Zillow Web Service ID)
set_zwsid <- function(x) {
  options('zwsid' = x)
  return(invisible())
}