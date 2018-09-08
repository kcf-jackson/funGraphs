# Extract the function name
# lang0: A language object from rlang::parse_expr(); a parsed function.
extract_fun_name <- function(lang0) {
  if (is_fun(lang0)) return(as.character(lang0[[2]]))
  NULL
}

is_fun <- function(lang0) {
  rlang::is_call(lang0, c("<-", "="))
}
