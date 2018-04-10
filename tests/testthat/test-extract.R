context("test-extract.R")

response <- get_search_results("2144+Bigelow+Ave", "Seattle%2C+WA")
zwsid <- Sys.getenv("ZWSID")
set_zwsid(zwsid)

test_that("'get_links' Output the correct links", {

  df_check <- tibble::tribble(
    ~home_details, ~char_data, ~map_this_home, ~similar_sales, ~region_overview,
    "https://www.zillow.com/homedetails/2414-Bigelow-Ave-N-Seattle-WA-98109/48879021_zpid/",
    "http://www.zillow.com/homedetails/2414-Bigelow-Ave-N-Seattle-WA-98109/48879021_zpid/#charts-and-data",
    "http://www.zillow.com/homes/48879021_zpid/",
    "http://www.zillow.com/homes/comps/48879021_zpid/" ,
    "http://www.zillow.com/local-info/WA-Seattle/East-Queen-Anne/r_271856/"
    )

  expect_equal(get_links(response), df_check)
})

test_that("'get_loc' output correct location data", {

  df_check <- tibble::tribble(
    ~zip, ~street, ~city, ~state, ~latitude, ~longitude,
    98109L, "2414 Bigelow Ave N", "SEATTLE", "WA", 47.6405, -122.3481
  )

  expect_equal(get_loc(response), df_check)
})

test_that("'get_zestimate_alt' output correct zestimate data", {

  df_check <- tibble::tribble(
    ~currency, ~amount, ~last_updated, ~value_change, ~period, ~range_low, ~range_high,
    "USD",792587, "04/09/2018",   21793     ,   30     ,745032,    832216
  )

  expect_equal(get_zestimate_alt(response), df_check)
})


test_that("'get_near' output correct region data", {

  df_check <- tibble::tribble(
    ~region, ~id, ~type, ~indexvalue,
    "East Queen Anne",271856L, "neighborhood", 821600
  )

  expect_equal(get_near(response), df_check)
})

