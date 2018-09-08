#' Build a function-dependencies graph for an R package
#' @param dir0 A directory path.
#' @export
build_graph_from_dir <- function(dir0) {
  g_arr <- dir0 %>% build_graph_array() %>% tidy_graph_array()

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


build_graph_array <- function(dir0) {
  nl0 <- dir0 %>%
    get_files() %>%
    purrr::map(get_calls_in_file) %>%
    setNames(list.files(dir0))

  as.data.frame(cbind(
    file = rep(names(nl0), purrr::map_dbl(nl0, length)),
    func = unlist(purrr::map(nl0, names), F),
    contains = unlist(nl0, F)
  ))
}
