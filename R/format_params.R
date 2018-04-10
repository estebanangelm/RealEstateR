#' Format Address
#'
#' @description Converts the property address to the query param format
#'
#' @param address Address as a string (e.g., '2144 Bigelow Ave')
#'
#' @return proper format of address as a string (e.g., '2144+Bigelow+Ave')
#'
#' @export
format_address <- function(address) {
  formatted_address <- gsub("\\s", "+", address)
  return(formatted_address)
}

#' Format City and State
#'
#' @description Format city and state query parameter
#'
#' @param city City of property (e.g., 'Seattle')
#'
#' @param state State of property. Can be abbreviated (e.g., 'WA' for Washington)
#'
#' @return proper format of city/state as a string (e.g., 'Seattle%2C+WA')
#' @export
format_citystate <- function(city, state) {
  formatted_city <- gsub("\\s", "+", city)
  paste0(formatted_city,'%2C+',state)
}
