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
# get_zpid()
# -----------------------------------------------------------------------------

test_that("get_zpid() generates appropriate zpid", {
  address <- '2144+Bigelow+Ave'
  citystatezip <- 'Seattle%2C+WA'
  output <- get_zpid(zwsid, address, citystatezip)
  expect_equal(output, '48879021')
})

test_that("get_zestimate() provides price estimate of house given zpid", {
  zpid <- '48879021'
  output <- get_zestimate(zwsid, zpid)
  expect_equal(output, '783654')
})