#' Get Agent IDs Based On Location
#'
#' @param city A city of interest as a string.
#' (e.g. "Cincinnati")
#'
#' @param state A state of interest, where the city is in, as a string in 2 letters form.
#' (e.g. "OH")
#'
#' @examples
#' reviews_get_screennames('Cincinnati', 'OH')
#'
#' @return A dataframe that includes name, phone number, and id of agents in the location input.
#'
#' @export

# dependency
# library(tidyverse)
# library(xml2)
# library(jsonlite)
# library(rvest)
# library(stringr)

reviews_get_screennames <- function(city, state){
  # check conditions of city: an all-character input
  if (!is.character(city)){
    stop("Expect input of city to be a string.")
  } else if (str_detect(city, "[[:digit:]]")){
    stop("Expect input of city to be an all-character string.")
  }

  # check conditions of city: a 2-letter all-character input
  if (!is.character(state)){
    stop("Expect input of state to be a string.")
  } else if (str_detect(city, "[[:digit:]]")){
    stop("Expect input of state to be an all-character string.")
  } else if (str_count(state) != 2){
    stop("Expect 2-letter input of state (e.g. 'CA', 'OH', 'M').")
  }

  # initial setup
  city <- str_to_lower(city)
  state <- str_to_lower(state)

  page_range <- 1:25
  df <- NULL

  # scrape links and output info to dataframe
  for (p in page_range){
    content <- read_html(paste0("https://www.zillow.com/", city, "-", state, "/real-estate-agent-reviews/?page=", p))

    screenname <- content %>%
      html_nodes('p a') %>%
      html_attr('href') %>%
      strsplit(., "[/]") %>%
      map_chr(3) %>%
      unique()

    name <- content %>%
      html_nodes('.ldb-font-bold a') %>%
      html_text() %>%
      unique()

    phone <- content %>%
      html_nodes('.ldb-phone-number') %>%
      html_text() %>%
      unique()

    df <-  rbind(df, data.frame(name, screenname, phone, stringsAsFactors = FALSE))
  }

  df <- df %>%
    mutate(city = city, state = state)

  return(df)
}
