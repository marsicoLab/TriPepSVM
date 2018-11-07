options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) # count dont_use_bad_overy

out <- args[1]

threeMer <- function(x){
  res <- c()
  for (i in 1:length(x)){
    for (j in 1:length(x)){
      for (k in 1:length(x)){
        res <- c(res,paste(x[i],x[j],x[k],sep=""))
      }
    }  
  }
  return(res)
}

aa <- c("G","P","A","V","L","I","M","C","F","Y","W","H","K","R","Q","N","E","D","S","T")
AllThreeMer <- as.data.frame(threeMer(aa))

write.table(AllThreeMer, file=out,sep="\t",col.names=FALSE,row.names=FALSE,quote=FALSE)
