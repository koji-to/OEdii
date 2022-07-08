#' Eliminate outliers using deletion-imputation Iteration.
#'
#' @param data.df outlier elimination target dataset
#' @param imp imputation method's name ('mice' (default setting) or 'missForest')
#' @param del_rate deletion rate to complete dataset
#' @param elim_rate outlier elimination rate
#' @param iter the number of of iteration
#' @param penl calculation method of residual
#'
#' @importFrom mice mice
#' @importFrom mice complete
#' @importFrom missForest missForest
#' @importFrom missForest prodNA
#'
#' @examples
#' OEdii(iris[,-ncol(iris)], iter=100)
#' out <- OEdii(iris[,-ncol(iris)],iter=100)
#' out$elim
#'
#' @return $elim returns dataframe without outlier (eliminated)
#' 
#' $diff returns means of difference between imputed value and actual one about each field
#' 
#' $mcont returns the number of missing count of each field
#'
#' @export OEdii

OEdii<-function(data.df, imp="mice", del_rate=0.1, elim_rate=0.2, iter=1000, penl="SQD"){
  for(i in 1:iter){
    missing.df<-missForest::prodNA(data.df,noNA=del_rate)
    if(imp=="mice"){
      data_mice.mice<-mice::mice(missing.df, seed=i, m=1, printFlag=FALSE, remove.collinear = FALSE)
      imp.df<-mice::complete(data_mice.mice,1)
    }else if(imp=="missForst"){
      imp.df<-missForest::missForest(missing.df)$ximp
    }
    if(penl=="ABD"){
      diff_sum_temp.df<-abs(data.df-imp.df)
      diff_sum_temp.df[is.na(diff_sum_temp.df)]<-0
      if(!exists("diff_sum.df")){#absolute difference
        diff_sum.df<-diff_sum_temp.df
        missing_count.df<-is.na(missing.df)
      }else{
        diff_sum.df<-diff_sum.df+diff_sum_temp.df
        missing_count.df<-missing_count.df+is.na(missing.df)
      }
    }else if(penl=="SQD"){#squared difference
      diff_sum_temp.df<-(data.df-imp.df)^2
      diff_sum_temp.df[is.na(diff_sum_temp.df)]<-0
      if(!exists("diff_sum.df")){
        diff_sum.df<-diff_sum_temp.df
        missing_count.df<-is.na(missing.df)
      }else{
        diff_sum.df<-diff_sum.df+diff_sum_temp.df
        missing_count.df<-missing_count.df+is.na(missing.df)
      }
    }
  }
  diff.df<-diff_sum.df/missing_count.df
  sum_diff.ls<-apply(diff.df,1,sum)
  data.df$rank<-rank(sum_diff.ls)
  elim.df<-subset(data.df,data.df$rank<=round(nrow(data.df)*(1-elim_rate)))

  elim.df<-elim.df[,-ncol(elim.df)]
  out.ls<-list(elim=elim.df,diff=diff.df,mcount=missing_count.df)
  return(out.ls)
}
