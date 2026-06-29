test_that("calc_mean works correctly", {
  expect_equal(calc_mean(c(1, 2, 3, 4, 5)), 3)
  expect_equal(calc_mean(c(10, 20, 30)), 20)
  expect_error(calc_mean(c()), "Vector is empty")
  expect_equal(calc_mean(c(1, 2, NA, 4, 5)), 3)
})

test_that("calc_median works correctly", {
  expect_equal(calc_median(c(1, 2, 3, 4, 5)), 3)
  expect_equal(calc_median(c(1, 2, 3, 4)), 2.5)
  expect_error(calc_median(c()), "Vector is empty")
})

test_that("calc_mode works correctly", {
  expect_equal(calc_mode(c(1, 2, 2, 3, 4, 5, 5, 5)), 5)
  expect_equal(calc_mode(c(1, 1, 1)), 1)
  expect_error(calc_mode(c()), "Vector is empty")
})

test_that("calc_q1 works correctly", {
  q1 <- calc_q1(c(1, 2, 3, 4, 5))
  expect_equal(q1, 2)
  expect_error(calc_q1(c()), "Vector is empty")
})

test_that("calc_q3 works correctly", {
  q3 <- calc_q3(c(1, 2, 3, 4, 5))
  expect_equal(q3, 4)
  expect_error(calc_q3(c()), "Vector is empty")
})

test_that("calc_iqr works correctly", {
  iqr <- calc_iqr(c(1, 2, 3, 4, 5))
  expect_equal(iqr, 2)
  expect_error(calc_iqr(c()), "Vector is empty")
})
