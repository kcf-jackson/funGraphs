#' Update graph coordinates from a SVG file
#' @param l0 A pairlist of edgelist and nodelist; the graph.
#' @param svg_file character; path to the svg file.
#' @export
update_graph_from_svg <- function(l0, svg_file) {
  coord <- new_coord(svg_file)
  l0$nodes$x <- NULL
  l0$nodes$y <- NULL
  l0 %>% dplyr::left_join(coord, by = "id")
}


# Extract coordinates from SVG file
# @example new_coord("test.svg")
new_coord <- function(svg_file) {
  dom <- xml2::read_html(svg_file)

  circles_dom <- dom %>%
    rvest::html_nodes("g") %>%
    Filter(node_contains_circle, .)

  new_coord <- circles_dom %>%
    Map(extract_xy, .) %>%
    do.call(rbind, .)
  id <- circles_dom %>%
    rvest::html_children() %>%
    Filter(node_is_circle, .) %>%
    Map(extract_circle_id, .)

  cbind(id, new_coord) %>%
    set_colnames(c("id", "x", "y"))
}


#-------------------------------------------------------------------------
# Check if a xml node contains a circle element
node_contains_circle <- function(x) {
  x %>% children_names() %>% contains("circle")
}
node_is_circle <- function(x) {
  x %>% rvest::html_name() %>% is("circle")
}
children_names <- function(x) {
  x %>%
    rvest::html_children() %>%
    purrr::map_chr(rvest::html_name)
}
contains <- function(x, el) { el %in% x }
is <- function(x, el) { el == x }


# Extract the xy-transform in a node
extract_xy <- function(x) {
  x %>% extract_transform() %>% parse_transform() %>% tail(2)
}
# Extract the SVG 'transform' attribute of a node
extract_transform <- function(x) {
  rvest::html_attr(x, "transform")
}
# Parse SVG 'transform' attribute
# @example parse_svg_transform("matrix(1,0,0,1,885,360)")
parse_transform <- function(str0) {
  str0 %>%
    gsub(" ", "", .) %>%
    gsub("matrix[(]", "", .) %>%
    gsub("[)]", "", .) %>%
    strsplit(split = ",") %>%
    unlist() %>%
    as.numeric()
}


# Extract the circle id in a node
extract_circle_id <- function(x) {
  x %>% rvest::html_attr("id") %>% parse_id()
}
parse_id <- function(x) { gsub("id_", "", x) }

