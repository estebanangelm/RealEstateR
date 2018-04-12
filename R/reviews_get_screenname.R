#' Get Agent IDs Based On Location
#'
#' @author Ha Dinh
#'
#' @param name Full name of an agent/real-estate company you want to search for.
#'
#' @param city A city of interest as a string.
#' (e.g. "Cincinnati", "Los Angeles")
#' @param state A state abbreviation of interest, where the city is in, as a string in 2 letters form.
#' (e.g. "OH")
#'
#' @description
#' This function inputs a combination of agent name, city and state the agent is in,
#' then output the agent's screenname.
#'
#' @import stringr
#' @import xml2
#' @import jsonlite
#' @import rvest
#' @import tidyverse
#' @import purrr
#'
#' @examples
#' \dontrun{reviews_get_screennames('Rakesh Ram Real Estate Group', 'Cincinnati', 'OH')}
#'
#' @return A string.
#'
#' @export

reviews_get_screennames <- function(name, city, state){
  # check conditions of name: a character input
  if (!is.character(name)){
    stop("Expect input of name to be a string")
  }

  # check conditions of city: an all-character input
  if (!is.character(city)){
    stop("Expect input of city to be a string.")
  } else if (str_detect(city, "[[:digit:]]")){
    stop("Expect input of city to be an all-character string.")
  }

  # check conditions of state: a 2-letter all-character input
  if (!is.character(state)){
    stop("Expect input of state to be a string.")
  } else if (str_detect(state, "[[:digit:]]")){
    stop("Expect input of state to be an all-character string.")
  } else if (str_count(state) != 2){
    stop("Expect 2-letter input of state abbreviation.")
  }

  # initial setup
  name <- str_to_lower(name)
  city <- str_to_lower(city)
  state <- str_to_lower(state)

  # alternate dash to whitespace in name and city
  name <- ifelse(str_detect(name, "[[:space:]]"),
                 str_replace_all(name, "[[:space:]]", "%20"), name)

  city <- ifelse(str_detect(city, "[[:space:]]"),
         str_replace_all(city, "[[:space:]]", "-"), city)

  # scrape links and output info to dataframe
  content <- read_html(paste0("https://www.zillow.com/", city, "-", state, "/real-estate-agent-reviews/?name=", name))

  screenname <- content %>%
    html_node('p a') %>%
    html_attr('href') %>%
    strsplit(., "[/]") %>%
    map_chr(3)

  return(screenname)
}
