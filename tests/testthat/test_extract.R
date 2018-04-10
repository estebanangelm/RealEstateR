context("test-extract.R")

test_that("'get_links' Output the correct links", {

  response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
  zwsid <- Sys.getenv("ZWSID")
  set_zwsid(zwsid)
  search_xml <- xml2::read_xml(response)
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))


  df_check <- tibble::tribble(
    ~home_details, ~char_data, ~map_this_home, ~similar_sales, ~region_overview, ~sale_by_owner,
    "https://www.zillow.com/homedetails/2414-Bigelow-Ave-N-Seattle-WA-98109/48879021_zpid/",
    "http://www.zillow.com/homedetails/2414-Bigelow-Ave-N-Seattle-WA-98109/48879021_zpid/#charts-and-data",
    "http://www.zillow.com/homes/48879021_zpid/",
    "http://www.zillow.com/homes/comps/48879021_zpid/" ,
    "http://www.zillow.com/local-info/WA-Seattle/East-Queen-Anne/r_271856/",
    "http://www.zillow.com/east-queen-anne-seattle-wa/fsbo/"
    )


  res <- get_links(response)

  expect_equal(res$content, df_check)
  expect_equal(res$status, message)
  expect_equal(res$url, response$url)
  expect_equal(res$response, response)
  expect_s3_class(res, "zillow_api" )

})

test_that("'get_loc' output correct location data", {

  response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
  zwsid <- Sys.getenv("ZWSID")
  set_zwsid(zwsid)
  search_xml <- xml2::read_xml(response)
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))


  df_check <- tibble::tribble(
    ~zip, ~street, ~city, ~state, ~latitude, ~longitude,
    98109L, "2414 Bigelow Ave N", "SEATTLE", "WA", 47.6405, -122.3481
  )

  res <- get_loc(response)

  expect_equal(res$content, df_check)
  expect_equal(res$status, message)
  expect_equal(res$url, response$url)
  expect_equal(res$response, response)
  expect_s3_class(res, "zillow_api" )

})

test_that("'get_zestimate_alt' output correct zestimate data", {

  response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
  zwsid <- Sys.getenv("ZWSID")
  set_zwsid(zwsid)
  search_xml <- xml2::read_xml(response)
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))


  res <- get_zestimate_alt(response)

  expect_is(res$content, c("tbl_df", "tbl", "data.frame"))
  expect_equal(res$status, message)
  expect_equal(res$url, response$url)
  expect_equal(res$response, response)
  expect_s3_class(res, "zillow_api" )

})


test_that("'get_near' output correct region data", {

  response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
  zwsid <- Sys.getenv("ZWSID")
  set_zwsid(zwsid)
  search_xml <- xml2::read_xml(response)
  message <- xml2::xml_text(xml2::xml_find_first(search_xml, "message/text"))


  df_check <- tibble::tribble(
    ~region, ~id, ~type, ~indexvalue,
    "East Queen Anne",271856L, "neighborhood", 821600
  )

  res <- get_near(response)

  expect_equal(res$content, df_check)
  expect_equal(res$status, message)
  expect_equal(res$url, response$url)
  expect_equal(res$response, response)
  expect_s3_class(res, "zillow_api" )

})

