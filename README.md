
# OEdii

<!-- badges: start -->
<!-- badges: end -->
## Overview
**OEdii**: Outlier Elimination Technique Using Deletion - Imputation Iteration

OEdii is R package and outlier elimination technique using deletion-imputation iteration.

It combines prodNA (by missForest package) and Multiple Imputation Techniques (Mice and missForest in this version) to delete outlier cases.

See help text (in the making) to know more information and procedure of outlier deletion.
In this version, dataset must be constructed by ONLY numeric veriables.

## Installation

``` r
devtools::install_github("koji-to/OEdii")
```

## Dependencies
[mice](https://github.com/amices/mice)

[missForest](https://github.com/stekhoven/missForest)

## Usage

```
OEdii(
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
library(OEdii)

OEdic(iris[,-ncol(iris)], iter=100)
out <- OEdic(iris[,-ncol(iris)],iter=100)
out$elim
```
## Citation

@article{https://doi.org/10.1002/tee.23889,

author = {Toda, Koji and Tsunoda, Masateru},

title = {Outlier Elimination Technique Using Deletion-Imputation Iteration for Fault-Prone Module Detection},

journal = {IEEJ Transactions on Electrical and Electronic Engineering},

volume = {18},

number = {10},

pages = {1653-1663},

keywords = {outlier elimination, missing value imputation, fault-prone detection},

doi = {https://doi.org/10.1002/tee.23889},

url = {https://onlinelibrary.wiley.com/doi/abs/10.1002/tee.23889},

eprint = {https://onlinelibrary.wiley.com/doi/pdf/10.1002/tee.23889},

abstract = {In software development, improving the efficiency of a testing process is important to ensure reliability during a limited development period. One approach to improving the testing process is identifying modules that are likely to contain faults (fault-prone modules) and allocate effort toward resolving them. For this purpose, many fault-prone module detection models have been proposed in previous studies. However, an appropriate fault-prone module detection model cannot be constructed if outliers, such as modules with a significantly large number of source code lines and branches, but no faults, are included. In this study, we propose a new outlier elimination technique that creates missing values (deleted values) to complete the data artificially and applies a missing value imputation technique using a regression approach. If the imputed value differs significantly from the actual (recorded) value, the proposed technique treats the values as outliers. We name the proposed technique Outlier Elimination Technique using Deletion-Imputation Iteration (OEdii), and its performance is verified experimentally. In general, our experimental results are more accurate than the previous outlier elimination techniques in the area under the ROC curve. © 2023 Institute of Electrical Engineers of Japan. Published by Wiley Periodicals LLC.}

}


