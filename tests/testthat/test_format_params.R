context("format_params.R")

# -----------------------------------------------------------------------------
# format_address()
# -----------------------------------------------------------------------------

test_that("format_address() converts address to appropriate format", {
  address <- '2144 Bigelow Ave'
  output <- format_address(address)
  expect_equal(output, '2144+Bigelow+Ave')
})

# -----------------------------------------------------------------------------
# format_citystate()
# -----------------------------------------------------------------------------

test_that("format_citystate() converts city and state to appropriate format", {
  city <- "Miami"
  state <- "FL"
  output <- format_citystate(city,state)
  expect_equal(output, 'Miami%2C+FL')
})

test_that("format_citystate() converts (multi-word) city
          and state to appropriate format", {
  city <- "New York"
  state <- "NY"
  output <- format_citystate(city,state)
  expect_equal(output, 'New+York%2C+NY')
})

