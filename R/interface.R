#' Plotting the package dependencies graph
#' @param l0 A pairlist of edgelist and nodelist.
#' @param browser Use "browser" or "viewer" to view the graph.
#' @export
start_app <- function(l0, browser = getOption("viewer")) {
  dir0 <- tempdir()
  asset_folder <- file.path(dir0, "assets")
  if (!file.exists(asset_folder)) dir.create(asset_folder)
  file.copy(
    from = system.file("index.html", package = "funGraphs"),
    to = dir0
  )
  fname <- file.path(asset_folder, "nodes_sample.json")
  fname_2 <- file.path(asset_folder, "edges_sample.json")
  jsonlite::write_json(as.data.frame(l0$nodes), fname)
  jsonlite::write_json(as.data.frame(l0$edges), fname_2)
  browseURL(file.path(dir0, "index.html"), browser = browser)
  dir0
}


#' Add plotting parameters to the graph data
#' @param l0 A pairlist of edgelist and nodelist.
#' @param layout (Optional) A 2-column matrix of nodes coordinates.
#' @export
prepare_graph <- function(l0, layout) {
  g <- igraph::graph_from_data_frame(l0$edges, vertices = l0$nodes)
  if (missing(layout)) {
    layout <- igraph::layout_with_sugiyama(g)$layout
    layout[,1] <- layout[,1] * 150
    layout[,2] <- layout[,2] * 100
    layout[,2] <- max(layout[,2]) - layout[,2]
    layout <- round(layout / 25 + 15) * 25 - 15  # node size: 15, grid size: 25
  }
  l0 %>%
    attach_ind() %>%
    attach_coord(coord = layout) %>%
    attach_color()
}


attach_ind <- function(l0) {
  lookup <- function(var, df0, look, ret) {
    df0[min(which(df0[, look] == var)), ret]
  }
  remap <- function(src, ndf) {
    purrr::map_dbl(src, ~lookup(.x, ndf, 2, 1))
  }

  ndf <- l0$nodes
  edf <- l0$edges
  nndf <- cbind(index = seq(nrow(ndf)) - 1, ndf)
  nedf <- cbind(from = remap(edf$from, nndf),
                to = remap(edf$to, nndf))
  list(nodes = nndf, edges = nedf)
}


attach_coord <- function(l0, coord) {
  l0$nodes %<>%
    cbind(x = coord[,1], y = coord[,2]) %>%
    as.data.frame()
  l0
}


attach_color <- function(l0, color) {
  color_group <- l0$nodes$group
  if (missing(color)) {
    num_group <- length(unique(color_group))
    if (num_group <= 12) {  # maximum number of colors in palette Set3
      color <- RColorBrewer::brewer.pal(num_group, 'Set3')
    } else {
      color_fun <- colorRampPalette(RColorBrewer::brewer.pal(12, 'Set3'))
      color <- color_fun(num_group)
    }
  }
  l0$nodes %<>%
    cbind(color = rep(color, table(color_group))) %>%
    as.data.frame()
  l0
}
