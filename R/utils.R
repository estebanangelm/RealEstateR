#' Exception handler: response type
#'
#' @description Check if the response is in XML format.
#'
#' @param response API response
#'
#' @keywords internal
check_response_type <- function(response){
  if (class(response) != "response") {
    stop("Input must be a response.")
  }
  if (httr::http_type(response) != "text/xml") {
    stop("API did not return XML", call. = FALSE)
  }
}

#' Get latitude of property
#'
#' @description Gets latitude coordinate of a given property
#'
#' @param response Object returned from get_search_results()
#'
#' @return Latitude as a float
#' @keywords internal
get_lat <- function(response) {
  search_xml <- xml2::read_xml(response)
  latitude <- round(xml2::xml_double(xml2::xml_find_all(search_xml, "//address//latitude")),4)
  return(latitude)
}

#' Get longitude of property
#'
#' @description Gets longitude coordinate of a given property
#'
#' @param response Object returned from get_search_results()
#'
#' @return Longitude as a float
#' @keywords internal
get_long <- function(response) {
  search_xml <- xml2::read_xml(response)
  longitude <- round(xml2::xml_double(xml2::xml_find_all(search_xml, "//address//longitude")),4)
  return(longitude)
}


#' Exception handler: response status
#'
#' @description Check if the API request is successful. Note that Zillow API always return `200`,
#' and the exact request status and message is buried inside the response.
#'
#' @details Throw errors if request is not successful and return the failed request code and messages.
#'
#' @param response API response
#'
#' @keywords internal
check_status <- function(response){
  search_xml <- xml2::read_xml(response)
  check_code <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/code"))
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))
  if (check_code  != "0") {
    stop(
      sprintf(
        "Zillow API request failed [%s]\n%s\n<%s>",
        check_code,
        message,
        "https://www.zillow.com/howto/api/APIOverview.htm"
      ),
      call. = FALSE
    )
  }
}

#' Check dataframe input
#'
#' @description Checks that input is a dataframe, has at least 1 column,
#' has column names "latitude", "longitude", "zestimate", "address"
#'
#' @param df Dataframe returned from get_neighbour_zestimates()
#'
#' @keywords internal
check_df_input <- function(df) {
  if(nrow(df) < 1 || !is.data.frame(df) ||
     !c("latitude", "longitude", "zestimate", "address") %in% colnames(df)) {
    stop("Input is in incorrect format.")
  }
}
