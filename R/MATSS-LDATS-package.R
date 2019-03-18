#' @importFrom utils data
#' 

## quiets concerns of R CMD check re: variables used in NSE functions
if (getRversion() >= "2.15.1") utils::globalVariables(
    c("analysis", "combine", "cpt", "fun", "lda", "map", "target"))