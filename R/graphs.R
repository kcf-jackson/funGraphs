#' Build a function-dependencies graph for an R package / a directory
#' @param dir0 A directory path.
#' @param exclude_file A character vector of file paths.
#' @export
build_graph_from_dir <- function(dir0, exclude_file = NULL) {
  dir0 %>%
    get_files() %>%
    setdiff(exclude_file) %>%
    build_graph_from_files()
}


#' Build a function-dependencies graph for a list of files
#' @param file_ls A character vector of file paths.
#' @export
build_graph_from_files <- function(file_ls) {
  g_arr <- file_ls %>% build_graph_array() %>% tidy_graph_array()

  cbind0 <- function(x, y) {
    if (purrr::is_empty(x) || purrr::is_empty(y)) return(NULL)
    cbind(x, y)
  }
  nodes <- data.frame(
    id = unlist(g_arr$func),
    label = unlist(g_arr$func),
    group = unlist(g_arr$file),
    stringsAsFactors = F
  )
  edges <- seq_along(g_arr$func) %>%
    purrr::map(~cbind0(g_arr$func[[.x]], g_arr$contains[[.x]])) %>%
    do.call(rbind, .) %>%
    as.data.frame(stringsAsFactors = F) %>%
    magrittr::set_colnames(c("from", "to"))

  list(nodes = nodes, edges = edges)
}


build_graph_array <- function(file_ls) {
  get_filename_from_path <- . %>% strsplit("/") %>% unlist() %>% tail(1)
  nl0 <- file_ls %>%
    purrr::map(get_calls_in_file) %>%
    setNames(purrr::map_chr(file_ls, get_filename_from_path))

  as.data.frame(cbind(
    file = rep(names(nl0), purrr::map_dbl(nl0, length)),
    func = unlist(purrr::map(nl0, names), F),
    contains = unlist(nl0, F)
  ))
}


# Exclude functions from certain packages (graph array)
tidy_graph_array <- function(x, exclude = NULL, packages = NULL) {
  pkg_fun <- unlist(x$func)
  x$contains %<>%
    purrr::map(~intersect(.x, pkg_fun))
  x
}
