
delayedAssign("isic_tilt_mapper", value = {
  msg <- "`isic_tilt_mapper` was deprecated in 0.0.0.9018. Please use `isic`."

  on_rcmd <- nzchar(Sys.getenv("R_CMD"))
  if (!on_rcmd) .Deprecated(msg = msg)

  isic
})
