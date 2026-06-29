# Question 1: Descriptive Statistics R Package

## Overview
A well-structured R package implementing 6 core descriptive statistics functions with full documentation, error handling, and unit tests.

## Functions

- **calc_mean(x)** - Arithmetic mean
- **calc_median(x)** - Median value
- **calc_mode(x)** - Most frequent value
- **calc_q1(x)** - First quartile (25th percentile)
- **calc_q3(x)** - Third quartile (75th percentile)
- **calc_iqr(x)** - Interquartile range

## Features

Roxygen2 documentation for all functions
Comprehensive error handling (empty vectors, NA values)
Unit tests using testthat framework
Standard R package structure (DESCRIPTION, NAMESPACE, R/, tests/)

## Usage

```r
library(descriptiveStats)

data <- c(1, 2, 2, 3, 4, 5, 5, 5, 6, 10)

calc_mean(data)      # 3.3
calc_median(data)    # 4.5
calc_mode(data)      # 5
calc_q1(data)        # 2.5
calc_q3(data)        # 5.5
calc_iqr(data)       # 3
```

## Installation

```r
devtools::load_all("question_1/descriptiveStats")
# or
devtools::install("question_1/descriptiveStats")
```

## Testing

```r
devtools::test("question_1/descriptiveStats")
```
