context("utils.R")

# -----------------------------------------------------------------------------
# check_response_type
# -----------------------------------------------------------------------------

test_that("'check_response_type()' return xml document properly", {
  uri <- paste0("http://www.zillow.com/webservice/ProReviews.htm?zws-id=", "abcd", "&screenname=", "mwalley0", "&output=json")
  response <- httr::GET(uri)
  expect_error(check_response_type(response))
})


# -----------------------------------------------------------------------------
# check_status()
# -----------------------------------------------------------------------------

test_that("'check_status()' handle error response properly", {
  zwsid <- "missing"
  address <- "random"
  citystatezip <- "random"
  response <- httr::GET(paste0("http://www.zillow.com/webservice/GetSearchResults.htm?zws-id=",
                               zwsid,"&address=", address,
                               "&citystatezip=", citystatezip))
  expect_error(check_status(response))
})
