context("zestimate.R")

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
# set_zwsid()
# -----------------------------------------------------------------------------

test_that("set_zwsid() is able to set zwsid as a global var", {
  set_zwsid(zwsid)
  global_var <- getOption("ZWSID")
  expect_true(is.character(global_var))
  expect_equal(nchar(global_var), 23)
})

# -----------------------------------------------------------------------------
# get_zpid()
# -----------------------------------------------------------------------------

test_that("get_zpid() generates appropriate zpid", {
  set_zwsid(zwsid)
  address <- '2144+Bigelow+Ave'
  citystatezip <- 'Seattle%2C+WA'
  output <- get_zpid(address, citystatezip)
  expect_equal(output, '48879021')
})

# -----------------------------------------------------------------------------
# get_zestimate()
# -----------------------------------------------------------------------------

test_that("get_zestimate() provides price estimate of house given zpid", {
  set_zwsid(zwsid)
  zpid <- '48879021'
  output <- get_zestimate(zpid)
  expect_equal(output, '791535')
})
