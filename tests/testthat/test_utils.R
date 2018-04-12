context("utils.R")

# -----------------------------------------------------------------------------
# check_type()
# -----------------------------------------------------------------------------

test_that("'check_type()' return xml document properly", {

  object <- jsonlite::toJSON("just for testing")

  expect_error(check_type(object))

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
