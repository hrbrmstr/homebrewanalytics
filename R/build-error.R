#' Retrieve Build Errors for the past 30 days for Homebrew Formulae
#'
#' @md
#' @return data frame (tibble) with build recipe and count;
#'         also includes a `meta` attribute with the metrics category and
#'         metrics tart/end date.
#' @export
#' @references <https://formulae.brew.sh/analytics/>
#' @examples
#' xdf <- brew_build_error_events()
#' attr(xdf, "meta")
brew_build_error_events <- function() {

  httr::GET(
    url = "https://formulae.brew.sh/api/analytics/build-error/homebrew-core/30d.json",
    httr::user_agent(HBUA)
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  meta <- out[c("category", "start_date", "end_date")]
  meta$start_date <- as.Date(meta$start_date)
  meta$end_date <- as.Date(meta$end_date)

  do.call(
    rbind.data.frame,
    lapply(out$formulae, function(.x) {
      .x$count <- as.numeric(gsub(",", "", .x$count))
      .x <- .x[,c("formula", "count")]
      colnames(.x) <- c("build_recipe", "count")
      .x
    })
  ) -> out

  class(out) <- c("tbl_df", "tbl", "data.frame")

  attr(out, "meta") <- meta

  out

}
