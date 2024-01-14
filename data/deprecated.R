delayedAssign("isic_tilt_mapper", value = {
  msg <- "`isic_tilt_mapper` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_isic_name())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_isic_name(), show_col_types = FALSE)
})
