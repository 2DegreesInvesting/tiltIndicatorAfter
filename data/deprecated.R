delayedAssign("isic_tilt_mapper", value = {
  msg <- "`isic_tilt_mapper` was deprecated in 0.0.0.9017. Please use `read_csv(tiltToyData::toy_isic_name())`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  read_csv(toy_isic_name())
})
