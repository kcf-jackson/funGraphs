start_app <- function(l0) {
  dir0 <- tempdir()
  asset_folder <- file.path(dir0, "assets")
  if (!file.exists(asset_folder)) dir.create(asset_folder)
  file.copy(
    from = system.file("index.html", package = "itDepends"),
    to = dir0
  )
  fname <- file.path(asset_folder, "nodes_sample.json")
  fname_2 <- file.path(asset_folder, "edges_sample.json")
  jsonlite::write_json(as.data.frame(l0$nodes), fname)
  jsonlite::write_json(as.data.frame(l0$edges), fname_2)
  browseURL(file.path(dir0, "index.html"))
  dir0
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
