list.of.packages <- c("kebabs","seqinr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


suppressPackageStartupMessages(require("kebabs"))
suppressPackageStartupMessages(require("seqinr"))

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE)

posDataFile = args[1]
negDataFile = args[2]
predFile = args[3]
k = as.numeric(args[4])
cost = as.numeric(args[5])
output_path = args[6]
out = args[7]
posW = args[8]
negW = args[9]
cutoff= as.numeric(args[10])
mode = args[11]
image = args[12]


if(mode == "training"){
  # get data
  print("read data")
  posData = read.fasta(file=posDataFile, seqtype="AA",seqonly=T, as.string=T)
  negData = read.fasta(file=negDataFile, seqtype="AA",seqonly=T, as.string=T)
  posData = AAVector(x=as.character(posData))
  negData = AAVector(x=as.character(negData))

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

  saveRDS(model, file = image)

}

####################################################################

if(mode=="prediction"){
  model = readRDS(file = image)
}

print("read prediction file")
predData = read.fasta(file=predFile, seqtype="AA",seqonly=T, as.string=T)
predData = AAVector(x=as.character(predData))
predAnn = read.fasta(file=predFile, seqtype="AA",seqonly=F, as.string=T)
predAnn = names(predAnn)
#predAnn = do.call(rbind,strsplit(predAnn,split="\\|"))[,2]

print("predict")
prob = predict(model, predData, predictionType="decision")
lab = predict(model, predData)

label = ifelse(prob>=cutoff,"RNA-binding protein","Non RNA-binding protein")

print("write prediction output table")
print(paste(output_path,out,sep="/"))
write.table(data.frame(ID=predAnn,SVMscore=prob,PREDICTION=label),sep="\t",file=paste(output_path,out,sep="/"),row.names = F,col.names = F,quote = F)
