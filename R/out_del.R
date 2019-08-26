#' Delete outlier cases
#'
#' @param data.df target dataset
#' @param imp imputation method name (mice (default) or missForest)
#' @param missing_ratio ratio to product NA
#' @param cut_off_ratio ratio of delete cases in whole data
#' @param iter times of iteration
#'
#' @importFrom mice mice
#' @importFrom missForest missForest
#' @importFrom missForest prodNA
#'
#' @examples
#' out_del(iris[,-ncol(iris)],iter=10)
#'
#' @export
#'

out_del<-function(data.df, imp="mice",missing_ratio=0.1 ,cut_off_ratio=0.2, iter=1000){
  for(i in 1:iter){
    missing.df<-missForest::prodNA(data.df,noNA=missing_ratio)
    if(imp=="mice"){
      data_mice.mice<-mice::mice(missing.df,seed=i,m=1)
      imp.df<-mice::complete(data_mice.mice,1)
    }else if(imp=="missForst"){
      imp.df<-missForest::missForest(missing.df)$ximp
    }
    if(!exists("diff_sum.df")){
      diff_sum.df<-abs(data.df-imp.df)
      missing_count.df<-is.na(missing.df)
    }else{
      diff_sum.df<-diff_sum.df+abs(data.df-imp.df)
      missing_count.df<-missing_count.df+is.na(missing.df)
    }
  }
  diff.df<-diff_sum.df/missing_count.df
  sum_diff.ls<-apply(diff.df,1,sum)
  data.df$rank<-rank(sum_diff.ls)
  deleted.df<-subset(data.df,data.df$rank<=round(nrow(data.df)*(1-cut_off_ratio)))

  #  if(!exists("cut_off_case")){
  #    cut_off_case<-row.names(subset(data.df,data.df$rank>round(nrow(data.df)*cf_ratio)))
  #  }else{
  #    cut_off_case<-c(cut_off_case,row.names(subset(data.df,data.df$rank>round(nrow(data.df)*cf_ratio))))
  #  }
  deleted.df<-deleted.df[,-ncol(deleted.df)]
  out.ls<-list(out_del=deleted.df,sum_diff=diff.df,miss_count=missing_count.df)
  return(out.ls)
}
#data: 外れ値除去対象のデータセット
#method: 外れ値除去のための予測データフレーム作成に使う欠損値補完手法
#cut_off_ratio: 欠損を全体の何%分作成するか
#iter: 欠損値作成を何回繰り返すか
#
#返り値1: 外れ値除去済みのデータフレーム
#返り値2: 補完値だけで作成されたデータフレーム（各セルの値は平均値）
#返り値1と2をリストで返す．$outと$impくらい？
