#' Get Search Results Response
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
#' @param address Street address of interest as a string (e.g., '2144+Bigelow+Ave')
#' 
#' @param citystatezip either the city and state or ZIP code of the street address (e.g., 'Seattle%2C+WA')
#' @export
get_zpid <- function(zwsid, address, citystatezip) {
  url_search <- 'http://www.zillow.com/webservice/GetSearchResults.htm?'
  result <- httr::GET(url = paste0(url_search, 'zws-id=', zwsid, '&address=', address, '&citystatezip=', citystatezip))
  search_xml <- xml2::read_xml(content(result, "text"))
  zpid <- xml2::xml_text(xml_find_all(search_xml, ".//zpid"))
  return(zpid)
}

get_zestimate <- function(zwsid, zpid) {
  url_zillow <- 'http://www.zillow.com/webservice/GetZestimate.htm?'
  result <- httr::GET(url = paste0(url_zillow,'zws-id=', zwsid, '&zpid=', zpid))
  zillow_xml <- xml2::read_xml(content(result, "text"))
  zestimate <- xml2::xml_text(xml_find_all(zillow_xml, ".//zestimate/amount"))
  currency <- xml2::xml_attr(xml_find_all(zillow_xml, ".//zestimate/amount"), "currency")
  return(zestimate)
}


# Get Zestimate
# 
# Example: 
# address <- '2144+Bigelow+Ave'
# citystatezip <- 'Seattle%2C+WA'
# get_zpid(zwsid, address, citystatezip)
# zpid <- get_zpid(zwsid, address, citystatezip)
# get_zestimate_zpid <- function(zwsid, zpid)



