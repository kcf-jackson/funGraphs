context("Test that get_all_calls extracts functions correctly")

test_that("Usual function extraction", {
  tmp <- rlang::parse_expr("a <- function(b, d) {print(b); print(d)}")
  expect_true(setequal(
    unique(unlist(get_all_calls(tmp))),
    c("<-", "function", "{", "print")
  ))
})

test_that("Function as arguments", {
  tmp <- rlang::parse_expr("a <- function(b, d) {purrr::map(b, print)}")
  expect_true(setequal(
    unique(unlist(get_all_calls(tmp))),
    c("<-", "function", "{", "::", "purrr", "map", "print")
  ))
})

test_that("Function in formula", {
  tmp <- rlang::parse_expr("a <- function(b, d) {purrr::map(b, ~print(.x))}")
  expect_true(setequal(
    unique(unlist(get_all_calls(tmp))),
    c("<-", "function", "{", "::", "purrr", "map", "print", "~")
  ))
})
