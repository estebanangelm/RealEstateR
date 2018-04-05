#' GetSearchResults Response
#' 
#' @description Retrieves GetSearchResults API response.
#' 
#' @param zwsid Access token
#' 
#' @param address Street address of interest as a string
#' (e.g., '2144+Bigelow+Ave')
#' 
#' @param citystatezip either the city and state or ZIP code
#' of the street address (e.g., 'Seattle%2C+WA')
#' 
#' @return API response
#' @export
get_search_results <- function(zwsid, address, citystatezip) {
  url_search <- 'http://www.zillow.com/webservice/GetSearchResults.htm?'
  result <- httr::GET(url = paste0(url_search, 'zws-id=', zwsid, '&address=', address, '&citystatezip=', citystatezip))
}
  
#' Get Zillow Property ID
#' 
#' @description 
#' Retrieves Zillow Property ID (zpid) from the GetSearchResults API.
#' 
#' @param zwsid Access token 
#' 
#' @param address Street address of interest as a string
#' (e.g., '2144+Bigelow+Ave')
#' 
#' @param citystatezip either the city and state or ZIP code
#' of the street address (e.g., 'Seattle%2C+WA')
#' 
#' @return zpid as a string
#' @export
get_zpid <- function(zwsid, address, citystatezip) {
  url_search <- 'http://www.zillow.com/webservice/GetSearchResults.htm?'
  result <- httr::GET(url = paste0(url_search, 'zws-id=', zwsid, '&address=', address, '&citystatezip=', citystatezip))
  search_xml <- xml2::read_xml(httr::content(result, "text"))
  zpid <- xml2::xml_text(xml2::xml_find_all(search_xml, ".//zpid"))
  return(zpid)
}

#' Get Zestimate
#' 
#' @description Retrives zestimate information for a specified zpid.
#' 
#' @param zwsid Access token
#' 
#' @param zpid Zillow property ID (zpid)
#' 
#' @return Zestimate of house (in USD)
#' @export
get_zestimate <- function(zwsid, zpid) {
  url_zillow <- 'http://www.zillow.com/webservice/GetZestimate.htm?'
  result <- httr::GET(url = paste0(url_zillow,'zws-id=', zwsid, '&zpid=', zpid))
  zillow_xml <- xml2::read_xml(content(result, "text"))
  zestimate <- xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//zestimate/amount"))
  currency <- xml2::xml_attr(xml2::xml_find_all(zillow_xml, ".//zestimate/amount"), "currency")
  return(zestimate)
}


