<!-- README.md is generated from README.Rmd. Please edit that file -->
RealEstateR <img src="man/figures/realestater_logo.png" align="right" width="140" />
------------------------------------------------------------------------------------

[![Travis build
status](https://travis-ci.org/estebanangelm/RealEstateR.svg?branch=master)](https://travis-ci.org/estebanangelm/RealEstateR)[![Coverage
status](https://codecov.io/gh/estebanangelm/RealEstateR/branch/master/graph/badge.svg)](https://codecov.io/github/estebanangelm/RealEstateR?branch=master)

RealEstateR is a package that analyzes real estate data from the Zillow
API.

Installation
------------

You can install the latest development version of RealEstateR using
devtools:

    devtools::install_github("estebanangelm/RealEstateR")

API Token
---------

To use the Zillow API in this package, you will need to get a Zillow Web
Services ID (ZWSID) which can be done by registering
[here](http://www.zillow.com/webservice/Registration.htm).

Once you have your ZWSID, you can set it:

    library(RealEstateR)
    set_zwsid("your-zwsid-here")

This allows you to make API calls within the package without having to
pass in your ZWSID every time.

**Note:** If you are contributing to the package and need to run tests
locally, add your ZWSID to `.Renviron`. You can do this by running the
following command in your RStudio console:

    Sys.setenv(ZWSID='your-key-here')

Example
-------

To get search results response:

    response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")

To get information about the property’s `zpid`:

    response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
    get_zpid(response)

To get location data:

    response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
    get_loc(response)

To get information about similar recent sales for a specific property:

    get_comp_df(zpid = "48749425", count = 5)

To get screenname of a real estate agent in a specific city:

    reviews_get_screennames(name = 'Rakesh Ram Real Estate Group', city = 'Cincinnati', state = 'OH')

To get information of up-to 5 real estate agents based on their
screennames:

    screennames <- c("Rakesh Ram Real Estate Group", "mwalley0", "pamelarporter", "klamping4", "Cincysrealtor")

    reviews(screennames)

Limitations
-----------

In Zillow’s Terms of Use, reverse-engineering like scrapping is not
allowed. Thus, it is not possible to get screennames of all real-estate
agents in a location through web scrapping method. At the same time,
Zillow API allows 1000 requests per day, which also limits the number of
agents’ reviews information you can get. Reflecting from this
limitation, our `reviews` function only allows you to search for reviews
information of 5 agents at most.

Contribution
------------

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.
