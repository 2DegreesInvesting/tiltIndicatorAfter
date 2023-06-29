test_that("`pctr_product` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::pctr_product))
})

test_that("`pctr_company` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::pctr_company))
})

test_that("`ictr_product` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::ictr_product))
})

test_that("`ictr_company` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::ictr_company))
})

test_that("`pstr_product` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::pstr_product))
})

test_that("`pstr_company` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::pstr_company))
})

test_that("`istr_product` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::istr_product))
})

test_that("`istr_company` hasn't changed", {
  expect_snapshot(format_robust_snapshot(tiltIndicatorAfter::istr_company))
})
