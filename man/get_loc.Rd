% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract.R
\name{get_loc}
\alias{get_loc}
\title{Get location data from the API response}
\usage{
get_loc(response)
}
\arguments{
\item{response}{The API response from `get_search_results`}
}
\value{
A data frame including the following information:
\itemize{
  \item ZIP code
  \item Full address: street, city, state
  \item Latitude and longitude
}
}
\description{
Get the location data of the property from the API response,
e.g. ZIP, full address, latitude and longitude
}
\examples{
\dontrun{
response <- get_search_results("2144 Bigelow Ave", "Seattle", "WA")
get_loc(response)

get_search_results("2144 Bigelow Ave", "Seattle", "WA") \%>\%
  get_loc()
}
}
