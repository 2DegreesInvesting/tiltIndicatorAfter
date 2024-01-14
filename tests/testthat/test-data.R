test_that("`pctr_product` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::pctr_product))
})

test_that("`pctr_company` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::pctr_company))
})

test_that("`ictr_product` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::ictr_product))
})

test_that("`ictr_company` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::ictr_company))
})

test_that("`pstr_product` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::pstr_product))
})

test_that("`istr_product` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::istr_product))
})


test_that("`matches_mapper` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(read_csv(toy_ecoinvent_europages())))
})


test_that("`isic_name` hasn't changed", {
  expect_snapshot(format_minimal_snapshot(tiltIndicatorAfter::isic_name))
})
