context("comparisons.R")
context("set_zwsid.R")
library(ggplot2)

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# get_comp_df()
# -----------------------------------------------------------------------------

test_that("get_comp_df() creates a dataframe", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  expect_true(is.data.frame(get_comp_df("111",2)))
})

test_that("get_comp_df() with empty count retrieves 25 values", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  df <- get_comp_df("111")
  expect_equal(nrow(df), 25)
})

# -----------------------------------------------------------------------------
# price_plot()
# -----------------------------------------------------------------------------

test_that("price_plot() creates a ggplot object", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  expect_true(is.ggplot(price_plot("111")))
})

# -----------------------------------------------------------------------------
# price_ranges()
# -----------------------------------------------------------------------------

test_that("price_ranges() creates a list", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  expect_true(is.list(price_ranges("111")))
})

test_that("price_ranges() creates a list with two values", {
  set_zwsid('X1-ZWz1gc1h7u3b4b_68qz7')
  expect_equal(length(price_ranges("111")),2)
})
