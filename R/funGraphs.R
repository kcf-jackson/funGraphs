# A mini package to map out all the function dependencies
# Program structure
# 1. directory -> files
# 2. file -> calls
# 3. build graph

#' Import functions
#' @name import
#' @importFrom stats setNames
#' @importFrom utils find tail browseURL
#' @importFrom magrittr %>% %<>%
utils::globalVariables(".")
NULL
