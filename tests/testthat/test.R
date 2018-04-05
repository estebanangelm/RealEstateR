context("zestimate.R")

# -----------------------------------------------------------------------------
# Setup
# -----------------------------------------------------------------------------

address <- '2144+Bigelow+Ave'
citystatezip <- 'Seattle%2C+WA'
zwsid <- 'X1-ZWz1gbo7qcu13f_6sext'

get_zpid(zwsid, address, citystatezip)
zpid <- get_zpid(zwsid, address, citystatezip)
get_zestimate_zpid <- function(zwsid, zpid)
