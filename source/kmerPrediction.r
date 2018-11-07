list.of.packages <- c("kebabs","seqinr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


suppressPackageStartupMessages(require("kebabs"))
suppressPackageStartupMessages(require("seqinr"))

posDataFile = "/project/salmonella/data_collection/split_data/TrainNew/RBP_590.fasta"
negDataFile = "/project/salmonella/data_collection/split_data/TrainNew/NRBP_590.fasta"
predFile = "/project/salmonella/data_collection/split_data/TestNew/RBP_590.fasta"
k = 3
cost = 1
posW = 0.9
negW = 0.1

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

posDataFile = args[1]
negDataFile = args[2]
predFile = args[3]
k = as.numeric(args[4])
cost = as.numeric(args[5])
output_path = args[6]
out = args[7]
out2 = args[8]
posW = args[9]
negW = args[10]
cutoff= as.numeric(args[11])

# get data
print("read data")
posData = read.fasta(file=posDataFile, seqtype="AA",seqonly=T, as.string=T)
negData = read.fasta(file=negDataFile, seqtype="AA",seqonly=T, as.string=T)
posData = AAVector(x=as.character(posData))
negData = AAVector(x=as.character(negData))

predData = read.fasta(file=predFile, seqtype="AA",seqonly=T, as.string=T)
predData = AAVector(x=as.character(predData))
predAnn = read.fasta(file=predFile, seqtype="AA",seqonly=F, as.string=T)
predAnn = names(predAnn)
#predAnn = do.call(rbind,strsplit(predAnn,split="\\|"))[,2]

nn = length(negData)
np = length(posData)

Train = c(posData,negData)
TrainLabel = c(rep(1,np),rep(-1,nn))

kernel = spectrumKernel(k=k)

if(posW=="inversePropClassSize"){
  classWeights = c("1"=(nn+np)/np, "-1"=(nn+np)/nn)
}else{
  posW = as.numeric(posW)
  negW = as.numeric(negW)
  classWeights = c("1"=posW, "-1"= negW)
}

print("build model")
model <- kbsvm(x = Train,y = TrainLabel, kernel = kernel, pkg = "e1071", 
               svm = "C-svc", cost = cost, classWeights = classWeights)

print("get feature weights")
weights <- getFeatureWeights(model)

print("predict")
prob = predict(model, predData, predictionType="decision")
lab = predict(model, predData)

label = ifelse(prob>=cutoff,"RNA-binding protein","Non RNA-binding protein")

print("write prediction output table")
write.table(data.frame(ID=predAnn,SVMscore=prob,PREDICTION=label),sep="\t",file=paste(output_path,out,sep="/"),row.names = F,col.names = F,quote = F)

print("write weights output")
write.table(t(as.data.frame(weights)),file=paste(output_path,out2,sep="/"),sep="\t",append=F,quote=F,col.names=F,row.names=T)
