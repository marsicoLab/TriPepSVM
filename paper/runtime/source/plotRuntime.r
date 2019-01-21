#library(scales)
#library(ggplot2)

spotSeq_FileIn="/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/runtime/temp/SPOT_SEQ_RUNTIME.txt"
triPepSVM_plus_FileIn="/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/runtime/temp/TriPepSVM_+_TRAINING_PRED_RUNTIME.txt"
triPepSVM_minus_FileIn="/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/runtime/temp/TriPepSVM_-_TRAINING_PRED_RUNTIME.txt"

out = "/project/owlmayerTemporary/Bressin/Salmonella/runtime/runtime.pdf"

args <- commandArgs(trailingOnly = TRUE)

out = args[1]
spotSeq_FileIn=args[2]
triPepSVM_plus_FileIn=args[3]
triPepSVM_minus_FileIn=args[4]


getTime = function(X,resolution="hours"){
  if(resolution == "minutes"){
    print("minutes")
    res = (X$V2/1) + (X$V3/60)
  }else{
    print("hours")
    res = (X$V2/60) + (X$V3/3600)
  }
  RESULT = data.frame(V1=X$V1,V2=res)
  return(RESULT)
  
}

Runtime_spotSeq = read.table(spotSeq_FileIn, header = F, sep="\t", stringsAsFactors = F)
Runtime_spotSeq = getTime(Runtime_spotSeq, resolution = "hours")
Runtime_spotSeq$V2 = cumsum(Runtime_spotSeq$V2)
Runtime_spotSeq$V3 = rep("SPOT",nrow(Runtime_spotSeq))


Runtime_triPepSVM_plus = read.table(triPepSVM_plus_FileIn, header = F, sep="\t", stringsAsFactors = F)
Runtime_triPepSVM_plus = getTime(Runtime_triPepSVM_plus, resolution = "hours")
Runtime_triPepSVM_plus$V3 = rep("triPepSVM_plus",nrow(Runtime_triPepSVM_plus))


Runtime_triPepSVM_minus = read.table(triPepSVM_minus_FileIn, header = F, sep="\t", stringsAsFactors = F)
Runtime_triPepSVM_minus = getTime(Runtime_triPepSVM_minus, resolution = "hours")
Runtime_triPepSVM_minus$V3 = rep("triPepSVM_minus",nrow(Runtime_triPepSVM_minus))


DATA = rbind(Runtime_spotSeq, Runtime_triPepSVM_minus) #Runtime_triPepSVM_plus,

pdf(out)
#ggplot(DATA, aes(x = V1, y = V2, group = V3)) +  geom_line() + theme_bw() +
#  scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
#                labels = trans_format("log10", math_format(10^.x))) + annotation_logticks() +
#  labs(x = "# protein sequences", y="time [h]")
#scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
#            labels = trans_format("log10", math_format(10^.x))) + annotation_logticks()

plot(DATA$V1[DATA$V3=="SPOT"],DATA$V2[DATA$V3=="SPOT"],t="l",las=1, ylim=c(0,300),xlab="# protein sequences",ylab="time [h]" )
lines(DATA$V1[DATA$V3=="triPepSVM_minus"],DATA$V2[DATA$V3=="triPepSVM_minus"],t="l")

dev.off()


