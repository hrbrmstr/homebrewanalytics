.brew_analytics_events <- function(category = c("install",
                                                "install-on-request",
                                                "cask-install",
                                                "build-error",
                                                "os-version"),
                                   delta = c(30, 90, 365)) {

  category <- match.arg(
    category[1],
    c("install", "install-on-request", "cask-install", "build-error", "os-version")
  )

  stopifnot(delta[1] %in% c(30, 90, 365))

  httr::GET(
    url = sprintf(
      "https://formulae.brew.sh/api/analytics/%s/%sd.json",
      category,
      as.integer(delta[1])
    ),
    httr::user_agent(HBUA)
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  items <- out[["items"]]
  items[["category"]] <- out[["category"]]
  items[["start_date"]] <- as.Date(out[["start_date"]])
  items[["end_date"]] <- as.Date(out[["end_date"]])
  items[["total_items"]] <- out[["total_items"]]
  items[["total_count"]] <- out[["total_count"]]
  items[["percent"]] <- as.numeric(items[["percent"]]) / 100
  items[["count"]] <- as.numeric(gsub("[^[:digit:]]", "", items[["count"]]))

  class(items) <- c("tbl_df", "tbl", "data.frame")

  items

}

#' Retrieve Analytics Events for Homebrew Formulae for a Given Category
#'
#' Get analytics event data such as event count, percent and time range.
#'
#' The old Homebrew Analytics API had different endpoints for analytics
#' event metrics. These have been kept as wrappers to the new function and
#' other conveneince functions have been added. Thse are:
#'
#' - `[brew_build_error_events()]`
#' - `[brew_cask_install_events()]`
#' - `[brew_install_events()]`
#' - `[brew_install_on_request_events()]`
#' - `[brew_os_version_events()]`
#'
#' @md
#' @param category the category of the analytics events (the default is `install` events.
#'    The following are acceptable inputs:
#'    - `install`: the installation of all formulae
#'    - `install-on-request`: the requested installation of all formulae (i.e. not as a dependency of other formulae)
#'    - `cask-install`: the installation of all casks
#'    - `build-error`: the installation failure of all formulae
#'    - `os-version`: the macOS version of the machine that submitted an event
#' @param delta number of previous days to return. One of `30`, `90`, `365`
#' @note The results of the API call are memoised as they won't likely
#'       won't change between calls in the same R session. Use the
#'       facilities provided by the `memoise` package to clear the
#'       cache if you use this in a long running R session.
#' @return data frame (tibble)
#' @export
#' @references <https://formulae.brew.sh/docs/api/>
#' @examples
#' xdf <- brew_analytics_events("install", 30)
brew_analytics_events <- memoise::memoise(.brew_analytics_events)

#' @rdname brew_analytics_events
#' @export
brew_install_events <- function(delta = c(30, 90, 365)) {
  brew_analytics_events("install", delta)
}

#' @rdname brew_analytics_events
#' @export
brew_install_on_request_events <- function(delta = c(30, 90, 365)) {
  brew_analytics_events("install-on-request", delta)
}

#' @rdname brew_analytics_events
#' @export
brew_build_error_events <- function(delta = c(30, 90, 365)) {
  brew_analytics_events("build-error", delta)
}

#' @rdname brew_analytics_events
#' @export
brew_cask_install_events <- function(delta = c(30, 90, 365)) {
  brew_analytics_events("cask-install", delta)
}

#' @rdname brew_analytics_events
#' @export
brew_os_version_events <- function(delta = c(30, 90, 365)) {
  brew_analytics_events("os-version", delta)
}
