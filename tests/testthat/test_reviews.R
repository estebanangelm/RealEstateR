context("reviews.R")

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

# -----------------------------------------------------------------------------
# test input - inherit from reviews_get_screenname.R
# -----------------------------------------------------------------------------

# expect an all-character input for state
expect_error(reviews("cincinnati", 45220),
             "Expect input of state to be a string.")
expect_error(reviews("cincinnati", "A4"),
             "Expect input of state to be an all-character string.")

# expect 2-letter input for state
expect_error(reviews("los-angeles", "Cali"),
             "Expect 2-letter input of state abbreviation.")

# expect an all-character input for city
expect_error(reviews(45220, "OH"),
             "Expect input of city to be a string.")
expect_error(reviews("c1nc1n4t1", "OH"),
             "Expect input of city to be an all-character string.")

# -----------------------------------------------------------------------------
# test output
# -----------------------------------------------------------------------------


