#' Remove duplicate entries
#' @description This function removes functions that have the same name.
#' This is needed mostly for the function ".onLoad".
#' @param l0 A pairlist of edgelist and nodelist.
#' @export
#' @examples
#' \dontrun{
#' build_graph_from_dir("R/") %>%
#'   remove_duplicates() %>%
#'   prepare_graph_Rgraphviz() %>%     # Add plotting parameters
#'   start_app()
#' }
remove_duplicates <- function(l0) {
  duplicates <- table(l0$nodes$id) >= 2
  dup_funs <- duplicates %>% which() %>% names()

  cat("Nodes removed from the graph:", dup_funs, "\n")
  l0$nodes <- l0$nodes[-which(l0$nodes$id %in% dup_funs), ]
  l0$edges <- l0$edges[-c(which(l0$edges$from %in% dup_funs),
                          which(l0$edges$to %in% dup_funs)), ]
  l0
}


#' [Hot-fix] Remove entries with "|" symbol
#' @description igraphs does not allow the symbol "|" in a node's name.
#' Entries with such symbol are removed.
#' @param l0 A pairlist of edgelist and nodelist.
#' @export
#' @examples
#' \dontrun{
#' build_graph_from_dir("R/") %>%
#'   remove_vbar() %>%
#'   prepare_graph_Rgraphviz() %>%     # Add plotting parameters
#'   start_app()
#' }
remove_vbar <- function(l0) {
  which_contains_vbar <- . %>% {which(grepl('[|]', .))}
  nodes_rm_ind <- which_contains_vbar(l0$nodes$id)
  edges_rm_ind <- c(which_contains_vbar(l0$edges$from),
                    which_contains_vbar(l0$edges$to))

  cat("Nodes removed from the graph:", l0$nodes$id[nodes_rm_ind], "\n")
  l0$nodes <- l0$nodes[-nodes_rm_ind, ]
  l0$edges <- l0$edges[-edges_rm_ind, ]
  l0
}