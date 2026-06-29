#' Calculate Mean
#'
#' Calculates the arithmetic mean of a numeric vector
#'
#' @param x A numeric vector
#'
#' @return The mean value
#'
#' @examples
#' calc_mean(c(1, 2, 3, 4, 5))
#'
#' @export
calc_mean <- function(x) {
  x <- na.omit(x)
  if (length(x) == 0) stop("Vector is empty or all NA")
  sum(x) / length(x)
}

#' Calculate Median
#'
#' Calculates the median of a numeric vector
#'
#' @param x A numeric vector
#'
#' @return The median value
#'
#' @examples
#' calc_median(c(1, 2, 3, 4, 5))
#'
#' @export
calc_median <- function(x) {
  x <- na.omit(x)
  if (length(x) == 0) stop("Vector is empty or all NA")
  sorted <- sort(x)
  n <- length(sorted)
  if (n %% 2 == 1) {
    sorted[(n + 1) / 2]
  } else {
    (sorted[n / 2] + sorted[n / 2 + 1]) / 2
  }
}

#' Calculate Mode
#'
#' Calculates the mode (most frequent value) of a numeric vector
#'
#' @param x A numeric vector
#'
#' @return The mode value (returns first if multiple modes exist)
#'
#' @examples
#' calc_mode(c(1, 2, 2, 3, 4, 5, 5, 5))
#'
#' @export
calc_mode <- function(x) {
  x <- na.omit(x)
  if (length(x) == 0) stop("Vector is empty or all NA")
  freq <- table(x)
  as.numeric(names(freq)[which.max(freq)])
}

#' Calculate First Quartile
#'
#' Calculates the first quartile (25th percentile) of a numeric vector
#'
#' @param x A numeric vector
#'
#' @return The Q1 value
#'
#' @examples
#' calc_q1(c(1, 2, 3, 4, 5))
#'
#' @export
calc_q1 <- function(x) {
  x <- na.omit(x)
  if (length(x) == 0) stop("Vector is empty or all NA")
  quantile(x, 0.25, type = 7)[[1]]
}

#' Calculate Third Quartile
#'
#' Calculates the third quartile (75th percentile) of a numeric vector
#'
#' @param x A numeric vector
#'
#' @return The Q3 value
#'
#' @examples
#' calc_q3(c(1, 2, 3, 4, 5))
#'
#' @export
calc_q3 <- function(x) {
  x <- na.omit(x)
  if (length(x) == 0) stop("Vector is empty or all NA")
  quantile(x, 0.75, type = 7)[[1]]
}

#' Calculate Interquartile Range
#'
#' Calculates the interquartile range (Q3 - Q1) of a numeric vector
#'
#' @param x A numeric vector
#'
#' @return The IQR value
#'
#' @examples
#' calc_iqr(c(1, 2, 3, 4, 5))
#'
#' @export
calc_iqr <- function(x) {
  calc_q3(x) - calc_q1(x)
}
