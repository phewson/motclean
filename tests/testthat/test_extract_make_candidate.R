test_that("extract_make_candidate removes numeric suffixes", {
  expect_equal(
    extract_make_candidate("ALFA ROMEO GIULIETTA 1.4"),
    "ALFA ROMEO GIULIETTA"
  )

  expect_equal(
    extract_make_candidate("ABARTH 1000SP L/H/D"),
    "ABARTH"
  )
})

test_that("extract_make_candidate limits to first three tokens", {
  expect_equal(
    extract_make_candidate("LAND ROVER RANGE ROVER SPORT"),
    "LAND ROVER RANGE"
  )
})
