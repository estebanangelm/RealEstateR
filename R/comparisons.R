#' GetDeepComps Response
#'
#' @description Retrieves GetDeepComps API response.
#'
#' @param zpid property ID
#'
#' @param count number of comparable properties
#'
#' @return A data frame with n comparable properties and some of their main attributes.
get_deep_comps <- function(zpid, count) {
  zwsid <- getOption("ZWSID")
  base_url <- 'http://www.zillow.com/webservice/GetDeepComps.htm?'
  url_zillow <- paste0(base_url,'zws-id=', zwsid, '&zpid=', zpid,'&count=',count,'&rentzestimate=true')
  result <- httr::GET(url_zillow)
  return(result)
}

#' Get comparison data frame
#'
#' @description Retrieves some of the attributes of comparable properties estimated by Zillow.
#'
#' @param zpid property ID
#' @param count number of comparable properties (max 25)
#'
#' @return A data frame with n comparable properties and some of their main attributes.
#'
#' @export
get_comp_df <- function(zpid,count=25){
  if (count > 25){
    count <- 25
  }
  zwsid <- getOption("ZWSID")
  response <- get_deep_comps(zpid, count)
  zillow_xml <- xml2::read_xml(httr::content(response, "text"))

  #Define empty arrays for each property attribute

  zpid <- rep(NA,count)
  bedrooms <- rep(NA,count)
  bathrooms <- rep(NA,count)
  year <- rep(NA,count)
  size <- rep(NA,count)
  lot_size <- rep(NA,count)
  value <- rep(NA,count)
  rent <- rep(NA,count)

  comps <- xml2:::xml_find_all(zillow_xml, ".//comp")

  for (i in (1:count)){
    xml_text(xml2::xml_find_all(hola[3], ".//zpid"))
    zpid[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(comps[i], ".//zpid")))
    bedrooms[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//bedrooms")))
    bathrooms[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//bathrooms")))
    year[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//yearBuilt")))
    size[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//finishedSqFt")))
    lot_size[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//lotSizeSqFt")))
    value[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//zestimate/amount")))
    rent[i] <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//rentzestimate/amount")))
  }

  z_df <- dplyr::data_frame(zpid,bedrooms,bathrooms,year,size,lot_size,value,rent)
  return(z_df)
}

#' Price ranges plot
#'
#' @description Creates a boxplot with the price ranges of similar properties.
#'
#' @param zpid property ID
#'
#' @return A ggplot boxplot with the price ranges of similar properties.
#' @import ggplot2
#' @export
price_plot <- function(zpid) {
  response <- get_deep_comps(zpid, count=25)
  zillow_xml <- xml2::read_xml(httr::content(response, "text"))

  price_low <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zestimate/valuationRange/low")))
  price_high <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zestimate/valuationRange/high")))
  prices <- c(price_low,price_high)

  p <-ggplot2::ggplot(dplyr::data_frame(prices))+
        geom_boxplot(aes(x="",y=prices),color="#434D62",fill="#434D62",alpha=0.6)+
        ggtitle("Price Ranges")+
        scale_y_continuous("Prices",labels = scales::dollar_format())+
        theme_bw()+
        theme(plot.title = element_text(hjust = 0.5))

  return(p)
}

#' Price and rent ranges.
#'
#' @description Retrieves some estimates for similar rent and house prices for a certain property.
#'
#' @param zpid property ID
#'
#' @return A list with two elements: similar prices and similar rents.
#'
#' @export
price_ranges <- function(zpid){
  response <- get_deep_comps(zpid, count=25)
  zillow_xml <- xml2::read_xml(httr::content(response, "text"))

  price_low <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zestimate/valuationRange/low")))
  price_high <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zestimate/valuationRange/high")))
  prices <- c(price_low,price_high)

  rent_low <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/rentzestimate/valuationRange/low")))
  rent_high <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/rentzestimate/valuationRange/high")))
  rents <- c(rent_low,rent_high)

  return(list(prices = prices,rents = rents))
}
