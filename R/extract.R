#' Title
#'
#' @param response
#'
#' @return
#' @export
#'
#' @examples
get_links <- function(response){
  search_xml <- httr::content(response)
  home_details <- xml2::xml_text(xml_find_all(search_xml, "//links//homedetails"))
  char_data <- xml2::xml_text(xml_find_all(search_xml, "//links//graphsanddata"))
  map_this_home <- xml2::xml_text(xml_find_all(search_xml, "//links//mapthishome"))
  similar_sales <- xml2::xml_text(xml_find_all(search_xml, "//links//comparables"))
  region_overview <- xml2::xml_text(xml_find_all(search_xml, "//links//overview"))
  links_df <- tibble::tibble(home_details,
                             char_data,
                             map_this_home,
                             similar_sales,
                             region_overview)
  return(links_df)
}

#' Title
#'
#' @param response
#'
#' @return
#' @export
#'
#' @examples
get_zipcode <- function(response){
  search_xml <- httr::content(response)
  zip <- xml2::xml_text(xml_find_all(search_xml, "//address//zipcode"))
  return(zip)
}

#' Title
#'
#' @param response
#'
#' @return
#' @export
#'
#' @examples
get_coordinate <- function(response){
  search_xml <- httr::content(response)
  latitude <- xml2::xml_text(xml_find_all(search_xml, "//address//latitude"))
  longtitude <- xml2::xml_text(xml_find_all(search_xml, "//address//longtitude"))
  coordinate <- tibble::tibble(latitude, longtitude)
  return(coordinate)
}


#' Title
#'
#' @param response
#'
#' @return
#' @export
#'
#' @examples
get_zestimate_alt <- function(response){
  search_xml <- httr::content(response)
  amount <- xml2::xml_text(xml_find_all(search_xml, "//zestimate//amount"))
  currency <- xml2::xml_attr(xml_find_all(search_xml, "//zestimate//amount"), attr = "currency")
  last_updated <- xml2::xml_text(xml_find_all(search_xml, "//zestimate//last-updated"))
  value_change <- xml2::xml_text(xml_find_all(search_xml, "//zestimate//valueChange"))
  period <- xml2::xml_attr(xml_find_all(search_xml, "//zestimate//valueChange"), attr = "duration")
  range_low <- xml2::xml_text(xml_find_all(search_xml, "//zestimate//valuationRange/low"))
  range_high <- xml2::xml_text(xml_find_all(search_xml, "//zestimate//valuationRange/high"))
  res <- tibble::tibble(currency, amount, last_updated, value_change, period, range_low,range_high)
  return(res)
}

#' Title
#'
#' @param response
#'
#' @return
#' @export
#'
#' @examples
get_local <- function(response){
  search_xml <- httr::content(response)
  region <- xml2::xml_attr(xml_find_all(search_xml, "//localRealEstate//region"), attr = "name")
  id <- xml2::xml_attr(xml_find_all(search_xml, "//localRealEstate//region"), attr = "id")
  type <- xml2::xml_attr(xml_find_all(search_xml, "//localRealEstate//region"), attr = "type")
  indexvalue <- xml2::xml_text(xml_find_all(search_xml, "//localRealEstate//zindexValue"))
  local <- tibble::tibble(region, id, type, indexvalue)
  return(local)
}
