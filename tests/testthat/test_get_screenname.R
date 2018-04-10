context("reviews_get_screenname.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

zwsid <- function() {
  val <- Sys.getenv("ZWSID")
  if (identical(val, "")) {
    stop("`ZWSID` env var has not been set")
  }
  val
}
zwsid <- zwsid()

test_that("reviews_get_screennames() outputs a dataframe given a combination of city and state", {

  # -----------------------------------------------------------------------------
  # test input
  # -----------------------------------------------------------------------------

  # expect an all-character input for state
  expect_error(reviews_get_screennames("cincinnati", 45220),
               "Expect input of state to be a string.")
  expect_error(reviews_get_screennames("cincinnati", "A4"),
               "Expect input of state to be an all-character string.")

  # expect 2-letter input for state
  expect_error(reviews_get_screennames("los-angeles", "Cali"),
               "Expect 2-letter input of state abbreviation.")

  # expect an all-character input for city
  expect_error(reviews_get_screennames(45220, "OH"),
               "Expect input of city to be a string.")
  expect_error(reviews_get_screennames("c1nc1n4t1", "OH"),
               "Expect input of city to be an all-character string.")


  # -----------------------------------------------------------------------------
  # test output
  # -----------------------------------------------------------------------------

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
  expect_is(response$name, "character", "All columns should be in type character.")
  expect_is(response$screenname, "character", "All columns should be in type character.")
  expect_is(response$phone, "character", "All columns should be in type character.")
  expect_is(response$city, "character", "All columns should be in type character.")
  expect_is(response$state, "character", "All columns should be in type character.")

  # expect an empty dataframe if city and state combination contains too many results
  response_empty <- reviews_get_screennames("New-York", "NY")
  expect_equal(nrow(response_empty), 0)

  # expect an empty dataframe if location combination does not exist
  response_ghostLocation <- reviews_get_screennames("Madagasca", "CA")
  expect_equal(nrow(response_ghostLocation), 0)
})
