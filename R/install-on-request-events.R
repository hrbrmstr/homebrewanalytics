#' Retrieve Install-on-Requests nts for Homebrew Formulae
#'
#' @md
#' @param delta number of previous days to return. One of `30`, `90`, `365`
#' @return data frame (tibble) with formula, configure options and count;
#'         also includes a `meta` attribute with the metrics category and
#'         metrics tart/end date.
#' @export
#' @references <https://formulae.brew.sh/analytics/>
#' @examples
#' xdf <- brew_install_on_request_events(30)
#' attr(xdf, "meta")
brew_install_on_request_events <- function(delta = c(30, 90, 365)) {

  stopifnot(delta[1] %in% c(30, 90, 365))

  httr::GET(
    url = sprintf(
      "https://formulae.brew.sh/api/analytics/install-on-request/homebrew-core/%sd.json",
      as.integer(delta[1])
    ),
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
      if (nrow(.x) > 1) {
        .x$opts <- trimws(sub(sprintf("%s", .x$formula[1]), "", .x$formula, fixed=TRUE))
        .x$formula <- .x$formula[1]
      }
      .x$opts[1] <- NA_character_
      .x$count <- as.numeric(gsub(",", "", .x$count))
      .x[,c("formula", "opts", "count")]
    })
  ) -> out

  class(out) <- c("tbl_df", "tbl", "data.frame")

  attr(out, "meta") <- meta

  out

}
