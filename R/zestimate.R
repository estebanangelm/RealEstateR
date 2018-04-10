source('R/format_params.R')

#' GetSearchResults Response
#'
#' @description Retrieves GetSearchResults API response.
#'
#' @param address Street address of interest as a string
#' (e.g., '2144 Bigelow Ave')
#'
#' @param city City of the property
#'
#' @param state State of the property. Can be abbreviated (e.g., 'WA' for Washington)
#'
#' @return API response
#'
#' @export
get_search_results <- function(address, city, state) {
  zwsid <- getOption("ZWSID")
  address <- format_address(address)
  citystatezip <- format_citystate(city, state)
  base_url <- 'http://www.zillow.com/webservice/GetSearchResults.htm?'
  result <- httr::GET(url = paste0(base_url, 'zws-id=', zwsid, '&address=', address, '&citystatezip=', citystatezip))
  xml_result <- httr::content(result,'text')
  message <- xml2::xml_text(xml2::xml_find_all(xml2::read_xml(xml_result), ".//message/text"))
  if(grepl("error", message, ignore.case=TRUE)) {
    stop("Invalid address")
  }
  if(grepl("success", message, ignore.case=TRUE)) {
    return(result)
  }
}


#' Get Zillow Property ID
#'
#' @description Retrieves the Zillow Property ID (zpid) for a house
#' from the GetSearchResults API.
#'
#' @param address Street address of interest as a string
#' (e.g., '2144+Bigelow+Ave')
#'
#' @param city City of the property
#'
#' @param state State of the property. Can be abbreviated (e.g., 'WA' for Washington)
#'
#' @return zpid as a string
#'
#' @export
get_zpid <- function(address, city, state) {
  zwsid <- getOption("ZWSID")
  result <- get_search_results(address, city, state)
  search_xml <- xml2::read_xml(httr::content(result, "text"))
  zpid <- xml2::xml_text(xml2::xml_find_all(search_xml, ".//zpid"))
  return(zpid)
}

#' Get Zestimate
#'
#' @description Retrives zestimate information for a specified zpid.
#'
#' @param zpid property ID
#'
#' @return Estimated price of house as a numeric (in USD)
#'
#' @export
get_zestimate <- function(zpid) {
  zwsid <- getOption("ZWSID")
  url_zillow <- 'http://www.zillow.com/webservice/GetZestimate.htm?'
  result <- httr::GET(url = paste0(url_zillow,'zws-id=', zwsid, '&zpid=', zpid))
  zillow_xml <- xml2::read_xml(httr::content(result, "text"))
  zestimate <- xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//zestimate/amount"))
  currency <- xml2::xml_attr(xml2::xml_find_all(zillow_xml, ".//zestimate/amount"), "currency")
  return(as.numeric(zestimate))
}
