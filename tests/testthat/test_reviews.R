context("reviews.R")

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
# test input
# -----------------------------------------------------------------------------

# expect character input for screennames
expect_error(reviews(zwsid, 1:5),
             "Expect screennames input to be character.")

expect_error(reviews(zwsid, c(1,2,3)),
             "Expect screennames input to be character.")

expect_error(reviews(zwsid, c("mwalley0", "pamelarporter", "klamping4", "Cincysrealtor", "Gordon", "everydoorrealestate")),
             "Expect at most 5 screennames.")

# -----------------------------------------------------------------------------
# test output
# -----------------------------------------------------------------------------
screennames <- c("mwalley0", "pamelarporter", "klamping4", "Cincysrealtor")
test_df <- reviews(zwsid, screennames)

# Expect type of dataframe to be a tibble
expect_is(test_df, c("tbl_df","tbl","data.frame"))

# Check output dataframe
expect_output(str(test_df), "15 variables", ignore.case = TRUE)

expect_output(str(test_df), "$ status", fixed = TRUE)
expect_output(str(test_df), "$ name", fixed = TRUE)
expect_output(str(test_df), "$ screenname", fixed = TRUE)
expect_output(str(test_df), "$ title", fixed = TRUE)
expect_output(str(test_df), "$ businessName", fixed = TRUE)
expect_output(str(test_df), "$ businessAddress", fixed = TRUE)
expect_output(str(test_df), "$ phone", fixed = TRUE)
expect_output(str(test_df), "$ specialties", fixed = TRUE)
expect_output(str(test_df), "$ serviceArea", fixed = TRUE)
expect_output(str(test_df), "$ recentSaleCount", fixed = TRUE)
expect_output(str(test_df), "$ reviewCount", fixed = TRUE)
expect_output(str(test_df), "$ localknowledgeRating", fixed = TRUE)
expect_output(str(test_df), "$ processexpertiseRating", fixed = TRUE)
expect_output(str(test_df), "$ responsivenessRating", fixed = TRUE)
expect_output(str(test_df), "$ negotiationskillsRating", fixed = TRUE)

# check when ZWSID is invalid (or if users have already reached API limit)
expect_equal(reviews("abcd", "mwalley0"),
             "Either screenname or ZWSID input is invalid, or you have reached 1000 API calls limit for today!")
