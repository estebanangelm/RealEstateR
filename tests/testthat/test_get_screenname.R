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

## test expected output
response <- reviews_get_screennames("Cincinnati", "OH")

test_that("reviews_get_screennames() outputs a dataframe given correct combination of city and state", {

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
})
