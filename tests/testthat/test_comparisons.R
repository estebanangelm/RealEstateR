context("comparisons.R")
library(ggplot2)

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
# get_deep_comps()
# -----------------------------------------------------------------------------

test_that("get_deep_comps() outputs a response when
          a valid property ID is passed in", {
            set_zwsid(zwsid)
            output <- get_deep_comps(zpid="48749425", count=25)
            expect_equal(class(output), c("response"))
          })

# -----------------------------------------------------------------------------
# get_comp_df()
# -----------------------------------------------------------------------------

test_that("get_comp_df() creates a dataframe", {
  set_zwsid(zwsid)
  expect_true(is.data.frame(get_comp_df("48749425",2)))
})

test_that("get_comp_df() with empty count retrieves 25 values", {
  set_zwsid(zwsid)
  df <- get_comp_df("48749425")
  expect_equal(nrow(df), 25)
})

test_that("get_comp_df() with count > 25 retrieves 25 values", {
  set_zwsid(zwsid)
  df <- get_comp_df("48749425", count=30)
  expect_equal(nrow(df), 25)
})

# -----------------------------------------------------------------------------
# price_plot()
# -----------------------------------------------------------------------------

test_that("price_plot() creates a ggplot object", {
  set_zwsid(zwsid)
  expect_true(is.ggplot(price_plot("111")))
})

# -----------------------------------------------------------------------------
# price_ranges()
# -----------------------------------------------------------------------------

test_that("price_ranges() creates a list", {
  set_zwsid(zwsid)
  expect_true(is.list(price_ranges("111")))
})

test_that("price_ranges() creates a list with two values", {
  set_zwsid(zwsid)
  expect_equal(length(price_ranges("111")),2)
})
