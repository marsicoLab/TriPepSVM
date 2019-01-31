list.of.packages <- c("kebabs","RColorBrewer")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

suppressPackageStartupMessages(require("kebabs"))
suppressPackageStartupMessages(require("RColorBrewer"))


options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) 

path = args[1]
taxon = args[2]
out = args[3]

pos="RNA-binding protein"

tool = "RNAPred"
RBP_RNAPred = read.table(paste(path,"/",tool,"/RBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)
NRBP_RNAPred = read.table(paste(path,"/",tool,"/NRBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)

tool = "RBPPred"
RBP_RBPPred = read.table(paste(path,"/",tool,"/RBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)
NRBP_RBPPred = read.table(paste(path,"/",tool,"/NRBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)

tool = "SpotSeqRna"
RBP_SpotSeqRna = read.table(paste(path,"/",tool,"/RBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)
NRBP_SpotSeqRna = read.table(paste(path,"/",tool,"/NRBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)

tool = "TriPepSVM"
RBP_TriPepSVM = read.table(paste(path,"/",tool,"/RBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)
NRBP_TriPepSVM = read.table(paste(path,"/",tool,"/NRBP_",taxon,".",tool,".pred.txt",sep=""), header = F, sep = "\t", stringsAsFactors = F)

RESULT = data.frame()

### RNAPred
pred = ifelse(c(RBP_RNAPred$V3,NRBP_RNAPred$V3) == pos, 1, -1)
label = c(rep(1,nrow(RBP_RNAPred)),rep(-1,nrow(NRBP_RNAPred)))
performance = evaluatePrediction(pred, label, allLabels = c(1,-1), print = F)  
print(c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC))
RESULT = rbind(RESULT,c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC * 100 )) 

### SpotSeqRna
pred = ifelse(c(RBP_SpotSeqRna$V3,NRBP_SpotSeqRna$V3) == pos, 1, -1)
label = c(rep(1,nrow(RBP_SpotSeqRna)),rep(-1,nrow(NRBP_SpotSeqRna)))
performance = evaluatePrediction(pred, label, allLabels = c(1,-1), print = F)  
print(c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC))
RESULT = rbind(RESULT,c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC * 100 )) 

### RBPPred
pred = ifelse(c(RBP_RBPPred$V3,NRBP_RBPPred$V3) == pos, 1, -1)
label = c(rep(1,nrow(RBP_RBPPred)),rep(-1,nrow(NRBP_RBPPred)))
performance = evaluatePrediction(pred, label, allLabels = c(1,-1), print = F)  
print(c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC))
RESULT = rbind(RESULT,c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC * 100 )) 

### TriPepSVM
pred = ifelse(c(RBP_TriPepSVM$V3,NRBP_TriPepSVM$V3) == pos, 1, -1)
label = c(rep(1,nrow(RBP_TriPepSVM)),rep(-1,nrow(NRBP_TriPepSVM)))
performance = evaluatePrediction(pred, label, allLabels = c(1,-1), print = F)  
print(c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC))
RESULT = rbind(RESULT,c(performance$SENS, performance$SPEC, performance$BAL_ACC, performance$MAT_CC * 100 )) 

colnames(RESULT)=c("Sensitivity","Specificity","BACC","MCC")

pdf(out)
barplot(as.matrix(RESULT),beside=T,font=3, ylim=c(0,100), main = taxon)
dev.off()
