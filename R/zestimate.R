source('R/format_params.R')
source('R/utils.R')

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
  check_status(result)
  return(result)
}

#' Get Neighbour Zestimates
#'
#' @description Gets zestimates of neighbouring houses on the same street.
#'
#' @param address Street address of interest as a string
#' (e.g., '2144 Bigelow Ave')
#'
#' @param city City of the property
#'
#' @param state State of the property. Can be abbreviated (e.g., 'WA' for Washington)
#'
#' @return Dataframe with neighbour address, latitude and longitude coordinates,
#' and corresponding zestimate
#'
#' @export
get_neighbour_zestimates <- function(address, city, state) {
  street_number <- as.numeric(gsub("([0-9]+).*$", "\\1", address))
  street_name <- gsub('[0-9]+', '', address)
  neighbour_numbers <- append((street_number + c(1:10)), (street_number - c(1:10)))
  neighbours <- paste0(neighbour_numbers, street_name)
  neighbour_list <- c()
  zestimate_list <- c()
  lat_list <- c()
  long_list <- c()
  for(n in neighbours) {
    tryCatch({
      response <- get_search_results(n, city, state)
      zpid <- get_zpid(response)
      neighbour_zestimate <- get_zestimate(zpid)
      zestimate_list <- c(zestimate_list, neighbour_zestimate)
      neighbour_list <- c(neighbour_list, n)
      lat_list <- c(lat_list, get_lat(response))
      long_list <- c(long_list, get_long(response))
    },
    error=function(cond) {
      return(invisible())
    })
  }
  if(length(neighbour_list) == 0) {
    stop("No neighbours detected for this address")
  }
  neighbourhood_df <- data.frame(address = neighbour_list,
                                     zestimate = zestimate_list,
                                     latitude = lat_list,
                                     longitude = long_list)
  return(neighbourhood_df)
}



#' Plot neighbour zestimates
#'
#' @param df Dataframe returned from get_neighbour_zestimates()
#'
#' @return A ggplot map
#'
#' @importFrom ggmap ggmap get_map
#'
#' @export
plot_neighbour_zestimates <- function(df) {
  check_df_input(df)
  base <- suppressWarnings(ggmap(get_map(location = c(lon = mean(df$longitude),
                                          lat = mean(df$latitude)), zoom=18, maptype="roadmap"), extent="device"))
  p <- base +
    geom_point(data = df, aes(x=longitude, y=latitude, color=zestimate), size=7) +
    geom_text(data = df, aes(x=longitude, y=latitude, label=address),
              size = 3) +
    scale_color_distiller(palette="Spectral", labels = scales::dollar_format("$")) +
    ggtitle("Neighbourhood Zestimates") +
    theme_minimal() +
    theme(legend.text=element_text(size=6),
          legend.title=element_text(size=7))
  return(p)
}


#' Get Zillow Property ID
#'
#' @description Retrieves the Zillow Property ID (zpid) for a house
#' from the GetSearchResults API.
#'
#' @param response API response of get_search_results()
#'
#' @return zpid as a string
#'
#' @examples
#' \dontrun{
#' response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
#' get_zpid(response)
#' }
#'
#' @export
get_zpid <- function(response) {
  zwsid <- getOption("ZWSID")
  check_response_type(response)
  search_xml <- xml2::read_xml(httr::content(response, "text"))
  zpid <- xml2::xml_text(xml2::xml_find_all(search_xml, ".//zpid"))
  return(zpid)
}

#' Get Zestimate
#'
#' @description Retrieves zestimate information for a specified zpid.
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
