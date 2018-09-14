# directory -> files
get_files <- function(dir0) {
  file.path(dir0, list.files(dir0))
}


# file -> functions -> calls
get_calls_in_file <- function(fpath) {
  file(fpath) %>%
    rlang::parse_exprs() %>%
    purrr::map(get_calls_in_function) %>%
    unlist(recursive = F)
}


# function -> calls
get_calls_in_function <- function(fun0) {
  if (!is_fun(fun0)) return(NULL)
  list(unlist(get_all_calls(fun0[[3]]))) %>%
    setNames(extract_fun_name(fun0))
}


# Call -> all calls within
# @note It doesn't capture calls that appear in the function formal arguments
# @examples
# tmp <- rlang::parse_expr("a <- function(b, d) {print(b); print(d)}")
# get_all_calls(tmp)
get_all_calls <- function(call0) {
  if (rlang::is_call(call0)) {
    return(list(
      as.character(call0[[1]]),
      purrr::map(as.list(call0[-1]), get_all_calls)
    ))
  }
  # Include potential functions appeared as arguments
  if (is.null(call0) || is.list(call0)) return(NULL)
  as.character(call0)
}
