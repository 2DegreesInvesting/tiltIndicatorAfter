delayedAssign("isic_tilt_mapper", value = {
  msg <- "`isic_tilt_mapper` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_isic_name())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_isic_name(), show_col_types = FALSE)
})

delayedAssign("ep_companies", value = {
  msg <- "`ep_companies` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_europages_companies())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_europages_companies(), show_col_types = FALSE)
})

delayedAssign("ecoinvent_activities", value = {
  msg <- "`ecoinvent_activities` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_ecoinvent_activities())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_ecoinvent_activities(), show_col_types = FALSE)
})

delayedAssign("ecoinvent_inputs", value = {
  msg <- "`ecoinvent_inputs` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_ecoinvent_inputs())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_ecoinvent_inputs(), show_col_types = FALSE)
})

delayedAssign("matches_mapper", value = {
  msg <- "`matches_mapper` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_ecoinvent_europages())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_ecoinvent_europages(), show_col_types = FALSE)
})

delayedAssign("isic_name", value = {
  msg <- "`isic_name` was deprecated in 0.0.0.9017. Please use `readr::read_csv(tiltToyData::toy_isic_name())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  readr::read_csv(tiltToyData::toy_isic_name(), show_col_types = FALSE)
})

