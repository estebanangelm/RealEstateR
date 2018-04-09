#' GetSearchResults Response
#'
#' @description Retrieves GetSearchResults API response.
#'
#' @param address Street address of interest as a string
#' (e.g., '2144+Bigelow+Ave')
#'
#' @param citystatezip either the city and state or ZIP code
#' of the street address (e.g., 'Seattle%2C+WA')
#'
#' @return API response
#'
#' @export
get_search_results <- function(address, citystatezip) {
  zwsid <- getOption("ZWSID")
  url_search <- 'http://www.zillow.com/webservice/GetSearchResults.htm?'
  result <- httr::GET(url = paste0(url_search, 'zws-id=', zwsid, '&address=', address, '&citystatezip=', citystatezip))
  return(result)
}

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
  if(stringr::str_detect(address, '\\+')){
    formatted_address <- address
    print("Address already formatted")
  }
  formatted_address <- gsub("\\s", "+", address)
  return(formatted_address)
}

#' Get Zillow Property ID
#'
#' @description Retrieves the Zillow Property ID (zpid) for a house
#' from the GetSearchResults API.
#'
#' @param address Street address of interest as a string
#' (e.g., '2144+Bigelow+Ave')
#'
#' @param citystatezip either the city and state or ZIP code
#' of the street address (e.g., 'Seattle%2C+WA')
#'
#' @return zpid as a string
#'
#' @export
get_zpid <- function(address, citystatezip) {
  zwsid <- getOption("ZWSID")
  result <- get_search_results(address, citystatezip)
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
#' @return Zestimate of house (in USD)
#'
#' @export
get_zestimate <- function(zpid) {
  zwsid <- getOption("ZWSID")
  url_zillow <- 'http://www.zillow.com/webservice/GetZestimate.htm?'
  result <- httr::GET(url = paste0(url_zillow,'zws-id=', zwsid, '&zpid=', zpid))
  zillow_xml <- xml2::read_xml(httr::content(result, "text"))
  zestimate <- xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//zestimate/amount"))
  currency <- xml2::xml_attr(xml2::xml_find_all(zillow_xml, ".//zestimate/amount"), "currency")
  return(zestimate)
}


