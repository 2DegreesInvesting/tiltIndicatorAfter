# Source: tiltIndicator
pad_column <- function(data, pattern, width, pad) {
  check_matches_name(data, pattern)

  x <- get_column(data, pattern)
  if (!is.character(x)) {
    data[extract_name(data, pattern)] <- str_pad(x, width = width, pad = pad)
  }

  data
}
