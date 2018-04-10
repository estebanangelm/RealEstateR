context("reviews_get_screenname.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

library(tidyverse)
library(xml2)
library(jsonlite)
library(rvest)
library(stringr)
library(testthat)

zwsid <- function() {
  val <- Sys.getenv("ZWSID")
  if (identical(val, "")) {
    stop("`ZWSID` env var has not been set")
  }
  val
}
zwsid <- zwsid()

# -----------------------------------------------------------------------------
# reviews_get_screennames
# -----------------------------------------------------------------------------

test_that("reviews_get_screennames() outputs a dataframe given a combination of city and state", {

  response <- reviews_get_screennames("Cincinnati", "OH")

  # expect a dataframe with 5 columns
  expect_output(str(response), "5 variables", ignore.case = TRUE,
                          "There should be 5 columns in the dataframe")

  # expect a dataframe with column `name`, `screenname`, `phone`, `city`, `state`
  expect_output(str(response), "$ name", fixed = TRUE)
  expect_output(str(response), "$ screenname", fixed = TRUE)
  expect_output(str(response), "$ phone", fixed = TRUE)
  expect_output(str(response), "$ city", fixed = TRUE)
  expect_output(str(response), "$ state", fixed = TRUE)

  # expect type charactor for all columns
  expect_is(response$name, "character", "All columns should be in type character")
  expect_is(response$screenname, "character", "All columns should be in type character")
  expect_is(response$phone, "character", "All columns should be in type character")
  expect_is(response$city, "character", "All columns should be in type character")
  expect_is(response$state, "character", "All columns should be in type character")

  # expect an empty dataframe if city and state combination contains too many results
  response_empty <- reviews_get_screennames("New-York", "NY")
  expect_equal(nrow(response_empty), 0,
               "Returns nothing since there are too many results from your interested location.
               Try narrowing down your search.")

  # expect an empty dataframe if location combination does not exist
  response_ghostLocation <- reviews_get_screennames("Madagasca", "CA")
  expect_equal(nrow(response_ghostLocation), 0,
               "Returns nothing since the location combination does not exist.")

})
