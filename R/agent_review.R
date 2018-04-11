#' Get Reviews Detail of An Agent
#'
#' @param screenname An agent screenname of your choice
#'
#' @import xml2
#' @import jsonlite
#' @import tidyverse
#' @import purrr
#' @import httr
#'
#' @return list with agent info
#' @examples \dontrun{reviews("KellyGibbs")}
#' @export

agent_review <- function(screenname) {
  # call API key from get_zwsid
  zwsid <- getOption("ZWSID")

  # get all info of agents in a location
  uri <- paste0("http://www.zillow.com/webservice/ProReviews.htm?zws-id=", zwsid, "&screenname=", screenname, "&output=json")

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

  reviews_info <- list(name, screenname, title,
                              businessName, businessAddress, phone,
                              specialties, recentSaleCount, reviewCount,
                              localknowledgeRating, processexpertiseRating, responsivenessRating, negotiationskillsRating)

  return(reviews_info)
}
