..one_formula <- function(formula) {

  httr::GET(
    url = sprintf(
      "https://formulae.brew.sh/api/formula/%s.json",
      formula
    )
  ) -> res

  if (httr::status_code(res) != 200) {
    warning(
      "'", formula, "' not found in Homebrew/homebrew-core. Skipping...",
      call.=FALSE
    )
    return(NULL)
  }

  f <- httr::content(res, as = "text")
  f <- jsonlite::fromJSON(f)

  which(
    vapply(f, is_length_zero, FUN.VALUE = logical(1), USE.NAMES = FALSE)
  ) -> idx1

  which(
    vapply(f, class, FUN.VALUE = character(1), USE.NAMES = FALSE) == "list"
  ) -> idx2

  idx <- unique(c(idx1, idx2))

  for (i in idx) {
    f[[i]] <- I(list(f[[i]]))
  }

  out <- data.frame(f, stringsAsFactors = FALSE)

  class(out) <- c("tbl_df", "tbl", "data.frame")

  out

}

.one_formula <- memoise::memoise(..one_formula)

..all_formulae <- function() {

  httr::GET(
    url = "https://formulae.brew.sh/api/formula.json"
  ) -> res

  httr::stop_for_status(res)
  out <- httr::content(res, as = "text")
  out <- jsonlite::fromJSON(out)

  class(out) <- c("tbl_df", "tbl", "data.frame")
  out

}

.all_formulae <- memoise::memoise(..all_formulae)

.brew_formulae <- function(formulae = "all") {

  if ((length(formulae) == 1) && (formulae == "all")) {
    return(.all_formulae())
  }

  if ((length(formulae) == 1) && (formulae != "all")) {
    return(.one_formula(formulae))
  }

  if (length(formulae) > 1) {

    if ("all" %in% formulae) {
      stop(
        "Cannot combine 'all' witt a specified vector of formulae names.",
        call.=FALSE
      )
    }

    f <- lapply(formulae, .one_formula)
    bad <- vapply(f, is.null, FUN.VALUE = logical(1), USE.NAMES = FALSE)
    f <- f[!bad]

    if (length(f) > 0) {
      out <- do.call(rbind.data.frame, f)
      class(out) <- c("tbl_df", "tbl", "data.frame")
      return(out)
    } else {
      message("None of the specified formulae found.")
    }

  }

}

#' Retrieve formulae metadata for all homebrew-core formulae
#'
#' Get the `brew info --json=v1`` output for *all* current
#' Homebrew/homebrew-core formulae _or_ get the same output for
#' one or more current Homebrew/homebrew-core formulae with an extra
#' analytics key with analytics data by specify
#'
#' @md
#' @param formluae if "`all`" (the default) then metadata on all
#'        Homebrew/homebrew-core formulae will be returned. Otherwise
#'        the API will be queried for all formulae in the passed in
#'        character vector and returned, skipping (and warning) on
#'        any specified formula that does not exist.
#' @return data frame (tibble) with formula analytics data or `NULL` if
#'         what you looked for was not found.
#' @note The results of the API call are memoised as they won't likely
#'       won't change between calls in the same R session. Use the
#'       facilities provided by the `memoise` package to clear the
#'       cache if you use this in a long running R session.
#' @export
#' @references <https://formulae.brew.sh/docs/api/>
#' @examples
#' f <- brew_formulae() # same as manually specifying "all"
#' f <- brew_formulae("curl")
#' f <- brew_formulae(c("curl", "youtube-dl", "blemenge"))
brew_formulae <- memoise::memoise(.brew_formulae)
