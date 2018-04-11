#' Get Agent IDs Based On Location
#'
#' @author Ha Dinh
#'
#' @param city A city of interest as a string.
#' (e.g. "Cincinnati", "Los Angeles")
#' @param state A state abbreviation of interest, where the city is in, as a string in 2 letters form.
#' (e.g. "OH")
#'
#' @description
#' This function inputs a combination of city and state of your choice,
#' then output a dataframe that includes name, screenname, phone number,
#' city and state of agents from the input location.
#'
#' @import stringr
#' @import xml2
#' @import rvest
#'
#' @examples
#' \dontrun{df <- reviews_get_screennames('Los Angeles', 'CA')}
#'
#' @return A dataframe that includes name, phone number, and id of agents in the location input.
#'
#' @export

reviews_get_screennames <- function(city, state){
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
  city <- str_to_lower(city)
  state <- str_to_lower(state)
  page_range <- 1:25
  df <- NULL

  # alternate dash to whitespace in city
  city <- ifelse(str_detect(city, "[[:space:]]"),
         str_replace_all(city, "[[:space:]]", "-"),
         city
  )

  # scrape links and output info to dataframe
  for (p in page_range){
    content <- read_html(paste0("https://www.zillow.com/", city, "-", state, "/real-estate-agent-reviews/?page=", p))

    screenname <- content %>%
      html_nodes('p a') %>%
      html_attr('href') %>%
      strsplit("[/]") %>%
      purrr::map_chr(3) %>%
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
    dplyr::mutate(city = city, state = state)

  return(df)
}
