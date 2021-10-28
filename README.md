
# OEdic

<!-- badges: start -->
<!-- badges: end -->
## Overview
**OEdic**: Outlier Elimination Technique Using Deletion - Imputation Chain

OEdic is R package and outlier elimination technique using deletion-imputation chain.

It combines prodNA (by missForest package) and Multiple Imputation Techniques (Mice and missForest in this version) to delete outlier cases.

See help text (in the making) to know more information and procedure of outlier deletion.
In this version, dataset must be constructed by ONLY numeric veriables.

## Installation

``` r
devtools::install_github("koji-to/OEdic")
```

## Dependencies
[mice](https://github.com/amices/mice)

[missForest](https://github.com/stekhoven/missForest)

## Usage

```
OEdic(
  data.df,
  imp = "mice",
  del_rate = 0.1,
  elim_rate = 0.2,
  iter = 1000,
  penl = "SQD"
)
```

## Arguments
`data.df` target dataset

`imp` imputation method name ('mice' (default setting) or 'missForest')

`del_rate` deletion rate to complete dataset

`elim_rate` outlier elimination rate

`iter` the number of of iteration

`penl` calculation method of residual ('SQD': Squared difference (default setting) or 'ABD': Absolute difference)

## Values
`$elim` returns dataframe without outlier (eliminated)

`$diff` returns means of difference between imputed value and actual one about each field

`$mcont` returns the number of missing count of each field

## Example

``` r
library(OEdic)
OEdic(iris[,-ncol(iris)], iter=10)
out <- OEdic(iris[,-ncol(iris)],iter=10)
out$elim
```
