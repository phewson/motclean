test_that("collapse_initials collapses spaced initials", {
  expect_equal(
    collapse_initials("A C COBRA"),
    "AC COBRA"
  )

  expect_equal(
    collapse_initials("B M W 320"),
    "BMW 320"
  )
})

test_that("collapse_initials leaves non-initial text unchanged", {
  expect_equal(
    collapse_initials("ALFA ROMEO"),
    "ALFA ROMEO"
  )
})
