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
# @examples
# fun0 <- rlang::parse_expr("a <- function(x){print(x)}")
# get_calls_in_function(fun0)
get_calls_in_function <- function(fun0) {
  is_fun <- . %>% { rlang::is_call(., c("<-", "=")) }
  if (!is_fun(fun0)) return(NULL)

  fun_name <- as.character(fun0[[2]])
  fun_body <- fun0[[3]]
  get_all_calls(fun_body) %>%
    unlist() %>%   # remove nested structure
    list() %>%     # add back the list structure
    setNames(fun_name)
}


# Call -> all calls within
# @note It doesn't capture calls that appear in the function formal arguments
# @examples
# fun0 <- rlang::parse_expr("a <- function(b, d) {print(b); print(d)}")
# get_all_calls(fun0)
get_all_calls <- function(call0) {
  if (rlang::is_call(call0)) {
    fun_name <- as.character(call0[[1]])
    fun_rest <- as.list(call0[-1])
    return(list(fun_name, purrr::map(fun_rest, get_all_calls)))
  }
  # Include potential functions appeared as arguments
  if (is.null(call0) || is.list(call0)) return(NULL)
  as.character(call0)
}
