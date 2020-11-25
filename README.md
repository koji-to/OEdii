
# OEdic

<!-- badges: start -->
<!-- badges: end -->
## Overview
OEdic: Outlier Elimination Technique Using Deletion - Imputation Chain

OEdic is R poackage and outlier elimination technique using deletion-imputation chain.

It combines prodNA (by missForest package) and Multiple Imputation Techniques (Mice and missForest in this version) to delete outlier cases. See help text (TBD) to know more information and procedure of outlier deletion.
In this version, dataset must be constructed by ONLY numeric veriables.

## Installation

``` r
devtools::install_github("koji-to/OEdic")
```

## Example

``` r
library(OEdic)
## basic example code
OEdic(iris[,-ncol(iris)], iter=10)
out <- OEdic(iris[,-ncol(iris)],iter=10)
out$elim
```

## options
``` r
OEdic(data.df, imp="mice", del_rate=0.1, elim_rate=0.2, iter=1000, penl="SQD")
```
data.df: outlier elimination target dataset
imp: imputation method's name ('mice' (default setting) or 'missForest')
del_rate: deletion rate to complete dataset
elim_rate: outlier elimination rate
iter: the number of of iteration
penl: calculation method of residual(ABD: Absolute difference, SQD: Squared difference)
```
