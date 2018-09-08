# Exclude functions from certain packages (graph array)
tidy_graph_array <- function(x, exclude = NULL, packages = NULL) {
  pkg_fun <- unlist(x$func)
  x$contains %<>%
    purrr::map(~intersect(.x, pkg_fun)) %>%
    purrr::map(~exclude_functions_from_pkg(.x, exclude, packages))
  x
}

# Exclude functions from certain packages
exclude_functions_from_pkg <- function(vec0, exclude = NULL, packages = NULL) {
  get_pkg_dependency(vec0) %>%
    purrr::map(split_pkg_str) %>%
    purrr::map_lgl(~isTRUE(.x %in% packages)) %>%
    {vec0[!.]} %>%
    setdiff(exclude)
}

get_pkg_dependency <- function(vec0) {
  purrr::map(vec0, find)
}

split_pkg_str <- function(str0) {
  strsplit(str0, split = ":") %>% unlist() %>% tail(1)
}
