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

test_that("reviews_get_screennames() outputs an agent screenname given name, city and state", {

  # -----------------------------------------------------------------------------
  # test input
  # -----------------------------------------------------------------------------

  # expect a character input for name
  expect_error(reviews_get_screennames(456, "cincinnati", "oh"),
               "Expect input of name to be a string")

  # expect an all-character input for state
  expect_error(reviews_get_screennames("Rakesh Ram Real Estate Group", "cincinnati", 45220),
               "Expect input of state to be a string.")
  expect_error(reviews_get_screennames("Rakesh Ram Real Estate Group", "cincinnati", "A4"),
               "Expect input of state to be an all-character string.")

  # expect 2-letter input for state
  expect_error(reviews_get_screennames("Katie Pardee", "los-angeles", "Cali"),
               "Expect 2-letter input of state abbreviation.")

  # expect an all-character input for city
  expect_error(reviews_get_screennames("Rakesh Ram Real Estate Group", 45220, "OH"),
               "Expect input of city to be a string.")
  expect_error(reviews_get_screennames("Rakesh Ram Real Estate Group", "c1nc1n4t1", "OH"),
               "Expect input of city to be an all-character string.")


  # -----------------------------------------------------------------------------
  # test output
  # -----------------------------------------------------------------------------

  # output when inputs combination exist
  expect_equal(reviews_get_screennames("Anthony Butera", "Rochester", "NY"), "Anthony-Butera")
  expect_equal(length(reviews_get_screennames("Anthony Butera", "Rochester", "NY")), 1)

  # output when inputs combination does not exist
  expect_error(reviews_get_screennames("Ha Dinh", "Seattle", "WA"),
               "The agent name you want to search for in Seattle , WA does not exist.")
})
