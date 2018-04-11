#' Get Review Details of Agents in a Location
#'
#' @param city A city of interest as a string.
#' (e.g. "Cincinnati" or "Los-Angeles")
#'
#' @param state A state of interest, where the city is in, as a string in 2 letters form.
#' (e.g. "OH")
#'
#' @import stringr
#' @import xml2
#' @import jsonlite
#' @import rvest
#' @import tidyverse
#' @import purrr
#' @import httr
#'
#' @return A dataframe that includes details of agents, and their star reviews.
#'
#' @examples
#' reviews("Cincinnati", "OH")
#'
#' @export

reviews <- function(city, state){
  # call API key from get_zwsid
  zwsid <- getOption("ZWSID")

  screenname <- reviews_get_screennames(city, state)$screenname

  df <- NULL

  # get all info of agents in a location
  for (s in screenname){
    uri <- paste0("http://www.zillow.com/webservice/ProReviews.htm?zws-id=", zwsid, "&screenname=", s, "&output=json")

    content_json <- httr::GET(uri) %>% httr::content("text")
    content <- jsonlite::fromJSON(content_json)

    name <- content$response$results$proInfo$name
    screenname <- content$response$results$screenname
    title <- content$response$results$proInfo$title
    businessName <- content$response$results$proInfo$businessName
    businessAddress <- content$response$results$proInfo$address
    phone <- content$response$results$proInfo$phone
    specialties <- content$response$results$proInfo$specialties
    recentSaleCount <- content$response$results$proInfo$recentSaleCount
    reviewCount <- content$response$results$proInfo$reviewCount
    localknowledgeRating <- content$response$results$proInfo$localknowledgeRating
    processexpertiseRating <- content$response$results$proInfo$processexpertiseRating
    responsivenessRating <- content$response$results$proInfo$responsivenessRating
    negotiationskillsRating <- content$response$results$proInfo$negotiationskillsRating

    df <-  rbind(df, data.frame(name, screenname, title,
                                businessName, businessAddress, phone,
                                specialties, recentSaleCount, reviewCount,
                                localknowledgeRating, processexpertiseRating, responsivenessRating, negotiationskillsRating))
  }

  return(df)
}
