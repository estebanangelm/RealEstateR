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
# get_search_results()
# -----------------------------------------------------------------------------

test_that("get_search_results() outputs a response when
          valid property information is passed in", {
  set_zwsid(zwsid)
  address <- '2144 Bigelow Ave'
  city <- 'Seattle'
  state <- 'WA'
  output <- get_search_results(address, city, state)
  expect_equal(class(output), "response")
})

test_that("get_search_results() stops if property information is invalid", {
  set_zwsid(zwsid)
  address <- '2141 Bigelow Ave'
  city <- 'Seattle'
  state <- 'WA'
  expect_error(get_search_results(address,
                                  city,
                                  state), "Invalid address")
})


# -----------------------------------------------------------------------------
# get_zpid()
# -----------------------------------------------------------------------------

test_that("get_zpid() generates appropriate zpid", {
  set_zwsid(zwsid)
  address <- '2144 Bigelow Ave'
  city <- 'Seattle'
  state <- 'WA'
  response <- get_search_results(address, city, state)
  output <- get_zpid(response)
  expect_equal(output, '48879021')
})

# -----------------------------------------------------------------------------
# get_zestimate()
# -----------------------------------------------------------------------------

test_that("get_zestimate() provides price estimate of house given zpid", {
  set_zwsid(zwsid)
  zpid <- '48879021'
  output <- get_zestimate(zpid)
  expect_gte(output, 79000)
})
