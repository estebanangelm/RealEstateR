#' Exception handler: response type
#' @description Check if the response is in XML format.
#'
#' @param response API response
#'
#'
#' @keywords internal
check_type <- function(response){
  if (httr::http_type(response) != "text/xml") {
    stop("API did not return XML", call. = FALSE)
  }
}



#' Exception handler: response status
#' @description Check if the API request is successful. Note that Zillow API always return `200`,
#' and the exact request status and message is burried inside the response.
#' @details Throw errors if request is not successful and return the failed request code and messages.
#' @param response API response
#'
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

