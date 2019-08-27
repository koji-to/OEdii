#' Delete outlier cases
#'
#' @param data.df target dataset
#' @param imp imputation method name (mice (default) or missForest)
#' @param missing_ratio ratio to product NA
#' @param cut_off_ratio ratio of delete cases in whole data
#' @param iter the number of of iteration
#' @param calc_res calculation method of residual
#'
#' @importFrom mice mice
#' @importFrom mice complete
#' @importFrom missForest missForest
#' @importFrom missForest prodNA
#'
#' @examples
#' ODproNIm(iris[,-ncol(iris)],iter=10)
#'
#' @export

ODproNIm<-function(data.df, imp="mice",missing_ratio=0.1 ,cut_off_ratio=0.2, iter=1000, calc_res="arm"){
  for(i in 1:iter){
    missing.df<-missForest::prodNA(data.df,noNA=missing_ratio)
    if(imp=="mice"){
      data_mice.mice<-mice::mice(missing.df,seed=i,m=1,printFlag=FALSE)
      imp.df<-mice::complete(data_mice.mice,1)
    }else if(imp=="missForst"){
      imp.df<-missForest::missForest(missing.df)$ximp
    }
    if(calc_res=="arm"){#absolute residual mean
      if(!exists("diff_sum.df")){
        diff_sum.df<-abs(data.df-imp.df)
        missing_count.df<-is.na(missing.df)
      }else{
        diff_sum.df<-diff_sum.df+abs(data.df-imp.df)
        missing_count.df<-missing_count.df+is.na(missing.df)
      }
    }else if(calc_res=="rms"){#residual mean square
      if(!exists("diff_sum.df")){
        diff_sum.df<-(data.df-imp.df)^2
        missing_count.df<-is.na(missing.df)
      }else{
        diff_sum.df<-diff_sum.df+abs(data.df-imp.df)^2
        missing_count.df<-missing_count.df+is.na(missing.df)
      }
    }
  }
  diff.df<-diff_sum.df/missing_count.df
  sum_diff.ls<-apply(diff.df,1,sum)
  data.df$rank<-rank(sum_diff.ls)
  deleted.df<-subset(data.df,data.df$rank<=round(nrow(data.df)*(1-cut_off_ratio)))

  deleted.df<-deleted.df[,-ncol(deleted.df)]
  out.ls<-list(out_del=deleted.df,sum_diff=diff.df,miss_count=missing_count.df)
  return(out.ls)
}
