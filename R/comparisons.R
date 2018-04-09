#' Get comparison data frame
#'
#' @description Retrives some of the attributes of comparable properties estimated by Zillow.
#'
#' @param zpid property ID
#' @param count number of comparable properties (max 25)
#'
#' @return A data frame with n comparable properties and some of their main attributes.
#'
#' @export


get_comp_df <- function(zpid,count){
  zwsid <- getOption("ZWSID")
  if (count > 25){
    count = 25
  }
  url_zillow <- 'http://www.zillow.com/webservice/GetDeepComps.htm?'
  url_zillow <- paste0(url_zillow,'zws-id=', zwsid, '&zpid=', zpid,'&count=',count,'&rentzestimate=true')
  result <- httr::GET(url_zillow)
  zillow_xml <- xml2::read_xml(httr::content(result, "text"))

  zpid <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zpid")))
  bedrooms <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/bedrooms")))
  bathrooms <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/bathrooms")))
  year <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/yearBuilt")))
  size <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/finishedSqFt")))
  lot_size <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/lotSizeSqFt")))
  value <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zestimate/amount")))
  rent <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/rentzestimate/amount")))

  z_df <- dplyr::data_frame(zpid,bedrooms,bathrooms,year,size,lot_size,value,rent)
  return(z_df)
}

#' Price ranges plot
#'
#' @description Creates a boxplot with the price ranges of similar properties.
#'
#' @param zpid property ID
#' @param count number of comparable properties (max 25)
#'
#' @return A data frame with n comparable properties and some of their main attributes.
#'
#' @export


get_comp_df <- function(zpid){
  zwsid <- getOption("ZWSID")
  url_zillow <- 'http://www.zillow.com/webservice/GetDeepComps.htm?'
  url_zillow <- paste0(url_zillow,'zws-id=', zwsid, '&zpid=', zpid,'&count=25&rentzestimate=true')
  result <- httr::GET(url_zillow)
  zillow_xml <- xml2::read_xml(httr::content(result, "text"))

  zpid <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zpid")))
  bedrooms <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/bedrooms")))
  bathrooms <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/bathrooms")))
  year <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/yearBuilt")))
  size <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/finishedSqFt")))
  lot_size <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/lotSizeSqFt")))
  value <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/zestimate/amount")))
  rent <- as.numeric(xml2::xml_text(xml2::xml_find_all(zillow_xml, ".//comp/rentzestimate/amount")))

  z_df <- dplyr::data_frame(zpid,bedrooms,bathrooms,year,size,lot_size,value,rent)
  return(z_df)
}
