context("comparisons.R")
context("set_zwsid.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# get_zpid()
# -----------------------------------------------------------------------------

test_that("get_zpid() generates appropriate zpid", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  address <- '2144+Bigelow+Ave'
  citystatezip <- 'Seattle%2C+WA'
  output <- get_zpid(address, citystatezip)
  expect_equal(output, '48879021')
})

# -----------------------------------------------------------------------------
# get_zestimate()
# -----------------------------------------------------------------------------

test_that("get_zestimate() provides price estimate of house given zpid", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  zpid <- '48879021'
  output <- get_zestimate(zpid)
  expect_equal(output, '783654')
})
