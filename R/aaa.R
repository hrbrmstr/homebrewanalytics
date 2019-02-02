httr::user_agent(sprintf(
  "homebrewanalytics v%s R package; (<%s>)",
  utils::packageVersion("homebrewanalytics"),
  utils::packageDescription("homebrewanalytics")[["URL"]]
)) -> .HBUA

is_length_zero <- function(x) { length(x) == 0 }
is_length_gt_one <- function(x) { length(x) > 1 }