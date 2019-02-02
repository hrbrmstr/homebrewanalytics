context("api calls work as expected")
test_that("we can do something", {

  expect_is(brew_formulae(), "data.frame")
  expect_is(brew_formulae("curl"), "data.frame")
  expect_is(brew_formulae(c("curl", "wget")), "data.frame")
  expect_warning(brew_formulae("nothere"))
  expect_null(brew_formulae("nothere"))

  expect_is(brew_build_error_events(), "data.frame")
  expect_is(brew_cask_install_events(), "data.frame")
  expect_is(brew_install_events(), "data.frame")
  expect_is(brew_install_on_request_events(), "data.frame")
  expect_is(brew_os_version_events(), "data.frame")

})
