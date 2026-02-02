test_that("known misspellings are matched to canonical makes", {
  expect_equal(
    match_make("ALFA RAMEO")[["make_clean"]],
    "ALFA ROMEO"
  )

  expect_equal(
    match_make("ALFA RAMEA")[["make_clean"]],
    "ALFA ROMEO"
  )

  expect_equal(
    match_make("ABART 500")[["make_clean"]],
    "ABARTH"
  )

  expect_equal(
    match_make("ABARTH 1000SP L/H/D")[["make_clean"]],
    "ABARTH"
  )

  expect_equal(
    match_make("A C COBRA")[["make_clean"]],
    "AC"
  )
})

test_that("mid-confidence matches are reviewed", {
  res <- match_make("LEILANND CARS")

  expect_equal(res[["make_clean"]], "LEYLAND")
  expect_equal(res[["status"]], "REVIEW")
})


test_that("high-confidence matches are accepted", {
  res <- match_make("FORD")
  expect_equal(res[["make_clean"]], "FORD")
  expect_equal(res[["status"]], "ACCEPT")

})

test_that("low-frequency or ambiguous makes are rejected", {
  res <- match_make("JOHN SMITH SPECIAL")

  expect_equal(res[["status"]], "REJECT")
})

test_that("kit cars are rejected", {
  res <- match_make("LANCIA STRATOS REPLICA")
  expect_equal(res[["status"]], "REJECT")
})

test_that("rare but plausible vehicles are flagged for review", {
  res <- match_make("KINROAD KAYAK KARRIER")

  expect_equal(res[["status"]], "REVIEW")
})

test_that("internal registered vehicle data is available", {
  expect_true(exists("registered_cars"))
  expect_true(nrow(registered_cars) > 0)
})

test_that("reference data contains known makes", {
  expect_true("ALFA ROMEO" %in% registered_cars$make)
  expect_true("FORD" %in% registered_cars$make)
})

test_that("previously unmatched variants are now resolved", {
  expect_equal(
    match_make("ALFA RAMEO")[["make_clean"]],
    "ALFA ROMEO"
  )
})

test_that("can't match if numbers come before names (TECH DEBT)", {
  expect_equal(
    match_make("2000CHEVROLET SUBURBAN")[["make_clean"]],
    "OTHER"
  )
})
