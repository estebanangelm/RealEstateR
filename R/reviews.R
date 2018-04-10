
# dependency
# library(tidyverse)
# library(httr)
# library(xml2)
# library(jsonlite)
# library(xml2)
# library(rvest)

reviews <- function(city, state){
  # call API key from get_zwsid
  zwsid <- getOption("ZWSID")

  city <- "Cincinnati"
  state <- "OH"

  city <- str_to_lower(city)
  state <- str_to_lower(state)
  screenname <- reviews_get_screennames(city, state, 1)$screenname

  df <- NULL

  # get all info of agents in a location
  for (s in screenname){
    uri <- paste0("http://www.zillow.com/webservice/ProReviews.htm?zws-id=", zwsid, "&screenname=", s, "&output=json")

    content <- httr::GET(uri) %>% httr::content("text")

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




