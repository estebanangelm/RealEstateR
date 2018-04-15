context("reviews.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# test input
# -----------------------------------------------------------------------------
test_that("Expect character input for screennames", {

zwsid <- Sys.getenv("ZWSID")
set_zwsid(zwsid)

# expect character input for screennames
expect_error(reviews(zwsid, 1:5),
             "Expect screennames input to be character.")

expect_error(reviews(zwsid, c(1,2,3)),
             "Expect screennames input to be character.")

expect_error(reviews(zwsid, c("mwalley0", "pamelarporter", "klamping4", "Cincysrealtor", "Gordon", "everydoorrealestate")),
             "Expect at most 5 screennames.")
})
# -----------------------------------------------------------------------------
# test output
# -----------------------------------------------------------------------------

test_that("Test output", {

zwsid <- Sys.getenv("ZWSID")
set_zwsid(zwsid)

screennames <- c("mwalley0", "pamelarporter", "klamping4", "Cincysrealtor")

test1 <- reviews(screennames=screennames)
expect_type(test1, "list")

test_df <- reviews(zwsid, screennames)

# Expect type of dataframe to be a tibble
expect_type(test_df, "list")

# Check output dataframe
expect_equal(ncol(test_df), 15)

cols <- c("status", "name","screenname","title","businessName",
          "businessAddress","phone", "specialties", "serviceArea",
          "recentSaleCount","reviewCount", "localknowledgeRating",
          "processexpertiseRating",  "responsivenessRating","negotiationskillsRating")

expect_equal(colnames(test_df), cols)

})

test_that("Check when ZWSID is invalid", {

# check when ZWSID is invalid (or if users have already reached API limit)
expect_null(reviews("abcd", "mwalley0"),
             "Either screenname or ZWSID input is invalid, or you have reached 1000 API calls limit for today!")

})
