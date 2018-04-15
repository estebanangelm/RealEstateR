#' Get links from the API response
#'
#' @description Get property related links of the response
#'
#' @param response The API response from `get_search_results`
#'
#' @return A data frame with several links associated with the property
#' \itemize{
#'   \item Home details page
#'   \item Chart data page
#'   \item Map this home page
#'   \item Similar sales page
#'   \item Link to Region overview Page
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
#' get_links(response)
#'
#' get_search_results("2144 Bigelow Ave", "Seattle", "WA") %>%
#'   get_links()
#' }
get_links <- function(response){

  check_response_type(response)

  url <- response$url
  search_xml <- xml2::read_xml(response)

  check_code <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/code"))
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))

  check_status(response)

  home_details <- xml2::xml_text(xml2::xml_find_all(search_xml, "//links//homedetails"))
  char_data <- xml2::xml_text(xml2::xml_find_all(search_xml, "//links//graphsanddata"))
  map_this_home <- xml2::xml_text(xml2::xml_find_all(search_xml, "//links//mapthishome"))
  similar_sales <- xml2::xml_text(xml2::xml_find_all(search_xml, "//links//comparables"))
  region_overview <- xml2::xml_text(xml2::xml_find_all(search_xml, "//links//overview"))
  sale_by_owner <- xml2::xml_text(xml2::xml_find_all(search_xml, "//links//forSaleByOwner"))

  res <- list(status = message,
              url = url,
              response = response,
              content = tibble::tibble(home_details,
                                       char_data,
                                       map_this_home,
                                       similar_sales,
                                       region_overview,
                                       sale_by_owner)
              )
  structure(res, class = "zillow_api")
}

#' Get location data from the API response
#'
#' @description Get the location data of the property from the API response,
#' e.g. ZIP, full address, latitude and longitude
#'
#' @param response The API response from `get_search_results`
#'
#' @return A data frame including the following information:
#' \itemize{
#'   \item ZIP code
#'   \item Full address: street, city, state
#'   \item Latitude and longitude
#' }
#' @export
#' @import magrittr
#' @examples
#' \dontrun{
#' response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
#' get_loc(response)
#'
#' get_search_results("2144 Bigelow Ave", "Seattle", "WA") %>%
#'   get_loc()
#' }
get_loc <- function(response){

  check_response_type(response)

  url <- response$url
  search_xml <- xml2::read_xml(response)

  check_code <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/code"))
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))

  check_status(response)

  zip <- xml2::xml_integer(xml2::xml_find_all(search_xml, "//address//zipcode"))
  street <- xml2::xml_text(xml2::xml_find_all(search_xml, "//address//street"))
  city <- xml2::xml_text(xml2::xml_find_all(search_xml, "//address//city"))
  state <- xml2::xml_text(xml2::xml_find_all(search_xml, "//address//state"))
  latitude <- round(xml2::xml_double(xml2::xml_find_all(search_xml, "//address//latitude")),4)
  longitude <- round(xml2::xml_double(xml2::xml_find_all(search_xml, "//address//longitude")),4)

  res <- list(status = message,
              url = url,
              response = response,
              content = tibble::tibble(zip, street, city, state, latitude, longitude))

  structure(res, class = "zillow_api")

}


#' Get Zestimate related data from the API response
#'
#' @description The Zestimate® home value is Zillow's estimated market value for
#' an individual home and is calculated for about 100 million homes nationwide.
#' It is a starting point in determining a home's value and is not an official appraisal.
#' The Zestimate is automatically computed daily based on millions of public and
#' user-submitted data points.
#'
#' @param response The API response from `get_search_results`
#'
#' @return A data frame including the following information:
#' \itemize{
#'   \item Currency
#'   \item Zestimate
#'   \item Last updated
#'   \item 30-day change
#'   \item Valuation range (low & high)
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
#' get_zestimate_all(response)
#'
#' get_search_results("2144 Bigelow Ave", "Seattle", "WA") %>%
#'   get_zestimate_all()
#' }
get_zestimate_all <- function(response){

  check_response_type(response)

  url <- response$url
  search_xml <- xml2::read_xml(response)

  check_code <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/code"))
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))

  check_status(response)

  amount <- xml2::xml_double(xml2::xml_find_all(search_xml, "//zestimate//amount"))
  currency <- xml2::xml_attr(xml2::xml_find_all(search_xml, "//zestimate//amount"), attr = "currency")
  last_updated <- xml2::xml_text(xml2::xml_find_all(search_xml, "//zestimate//last-updated"))
  value_change <- xml2::xml_double(xml2::xml_find_all(search_xml, "//zestimate//valueChange"))
  period <- as.numeric(xml2::xml_attr(xml2::xml_find_all(search_xml, "//zestimate//valueChange"), attr = "duration"))
  range_low <- xml2::xml_double(xml2::xml_find_all(search_xml, "//zestimate//valuationRange/low"))
  range_high <- xml2::xml_double(xml2::xml_find_all(search_xml, "//zestimate//valuationRange/high"))

  res <- list(status = message,
              url = url,
              response = response,
              content = tibble::tibble(currency, amount, last_updated, value_change, period, range_low,range_high))

  structure(res, class = "zillow_api")
}

#' Get local real estate data from the API response
#'
#' @description Get local real estate data, e.g. Region, id, type(i.e. neighborhood), Zillow Home Value Index
#'
#' @param response The API response from `get_search_results`
#'
#' @return A data frame with local real estate data
#' \itemize{
#'   \item Region of the property
#'   \item Region id
#'   \item Region type
#'   \item Zillow Home Value Index
#' }
#'
#' @export
#'
#' @examples
#' \dontrun{
#' response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
#' get_near(response)
#'
#' get_search_results("2144 Bigelow Ave", "Seattle", "WA") %>%
#'   get_near()
#' }
get_near <- function(response){
  check_response_type(response)
  url <- response$url
  search_xml <- xml2::read_xml(response)

  check_code <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/code"))
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))

  check_status(response)

  region <- xml2::xml_attr(xml2::xml_find_all(search_xml, "//localRealEstate//region"), attr = "name")
  id <- as.integer(xml2::xml_attr(xml2::xml_find_all(search_xml, "//localRealEstate//region"), attr = "id"))
  type <- xml2::xml_attr(xml2::xml_find_all(search_xml, "//localRealEstate//region"), attr = "type")
  indexvalue <- as.numeric(
    gsub(",", "",
      xml2::xml_text(xml2::xml_find_all(search_xml, "//localRealEstate//zindexValue"))))

  res <- list(status = message,
              url = url,
              response = response,
              content = tibble::tibble(region, id, type, indexvalue))
  structure(res , class = "zillow_api")
}



#' @export
print.zillow_api <-  function(x, ...){
  cat("\n")
  cat("Status: ", x$status, "\n")
  cat("<Zillow: ", x$url, ">", sep = "")
  cat("\n\n")
  print(x$content)
  invisible(x)
}
