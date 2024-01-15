test_that("`ep_companies` is deprecated", {
  skip_on_ci()
  skip_on_rcmd()

  expect_snapshot(expect_equal(
    readr::read_csv(tiltToyData::toy_europages_companies()),
    ep_companies
  ))
})

test_that("`ecoinvent_activities` is deprecated", {
  skip_on_ci()
  skip_on_rcmd()

  expect_snapshot(expect_equal(
    readr::read_csv(tiltToyData::toy_ecoinvent_activities()),
    ecoinvent_activities
  ))
})

test_that("`ecoinvent_inputs` is deprecated", {
  skip_on_ci()
  skip_on_rcmd()

  expect_snapshot(expect_equal(
    readr::read_csv(tiltToyData::toy_ecoinvent_inputs()),
    ecoinvent_inputs
  ))
})

test_that("`matches_mapper` is deprecated", {
  skip_on_ci()
  skip_on_rcmd()

  expect_snapshot(expect_equal(
    readr::read_csv(tiltToyData::toy_ecoinvent_europages()),
    matches_mapper
  ))
})

test_that("`isic_name` is deprecated", {
  skip_on_ci()
  skip_on_rcmd()

  expect_snapshot(expect_equal(
    readr::read_csv(tiltToyData::toy_isic_name()),
    isic_name
  ))
})
