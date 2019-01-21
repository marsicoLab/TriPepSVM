#library("RSvgDevice")
suppressPackageStartupMessages(library(kebabs))
suppressPackageStartupMessages(library(gplots))
suppressPackageStartupMessages(library(RColorBrewer))


input_path = "/project/owlmayer/Annkatrin/GitHub/TriPepSVM/paper/cross_species_prediction/prediction"
args <- commandArgs(trailingOnly = TRUE) 

input_path=args[1]
out = args[2]
out2 = args[3]


taxon = list.dirs(input_path, full.names = F)[nchar(list.dirs(input_path, full.names = F))!=0]
pos="RNA-binding protein"


RESULT  = c()
for (tax1 in taxon){
  print(tax1)
  for (tax2 in taxon){
    print(tax2)
    RBP_file = paste(input_path,"/",tax1,"/","RBP_",tax2,".TriPepSVM.pred.txt",sep="")
    NRBP_file = paste(input_path,"/",tax1,"/","NRBP_",tax2,".TriPepSVM.pred.txt",sep="")
    
    RBP = read.table(RBP_file, sep="\t", header = F, stringsAsFactors = F)
    NRBP = read.table(NRBP_file, sep="\t", header = F, stringsAsFactors = F)
    
    pred = ifelse(c(RBP$V3,NRBP$V3) == pos, 1, -1)
    label = c(rep(1,nrow(RBP)),rep(-1,nrow(NRBP)))
    performance = evaluatePrediction(pred, label, allLabels = c(1,-1), print = F)  
    #print(c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC))
    #RESULT = rbind(RESULT,c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC * 100 )) 
    RESULT = c(RESULT, performance$BAL_ACC) 
    
    
  }
  
  
}

MAT = matrix(RESULT,nrow = 3,ncol = 3, byrow = T)
colnames(MAT)=taxon
rownames(MAT)=taxon

blue = colorRampPalette(brewer.pal(9,"Blues"))(100)

pdf(out)
heatmap.2(MAT,
          Colv = NA,
          Rowv = NA,
          cellnote=round(MAT,0),
          notecol="darkgrey",
          #main="",
          #cex.main = 1,
          #RowSideColors=besCol,
          trace="none",
          #srtCol=0,
          #cexCol = 1,
          #keysize=1,
          #breaks=seq(-0.1,0.9,1/100),
          #labRow=NA,
          dendrogram ="none",
          #key.xlab="Matthews correlation coefficient",
          #key.xlim=c(0,1),
          key.title="",
          density.info="none",
          #useRaster=TRUE,
          col=blue)
dev.off()

png(out2)
image(as.matrix(1:length(blue)),col=blue)
dev.off()