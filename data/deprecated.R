delayedAssign("isic_tilt_mapper", value = {
  msg <- "`isic_tilt_mapper` was deprecated in 0.0.0.9017. Please use `isic_name`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  isic_name
})
