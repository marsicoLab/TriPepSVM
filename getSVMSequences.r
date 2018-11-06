suppressPackageStartupMessages(require(seqinr))

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) # count dont_use_bad_overy

rbpFile <- args[1]
seqFile <- args[2]
outFile1 <- args[3]
pos <- as.numeric(args[4])

id <- read.table(rbpFile,colClasses = c("character"))[,1]
allSeq <- read.fasta(file=seqFile,as.string=T,seqtype="AA",seqonly = T)  
annot <- read.fasta(file=seqFile,as.string=T,seqtype="AA",seqonly = F)

annot <- getName(annot)

sannot <- strsplit(annot,split="\\|")
annot2 <- as.character(as.data.frame(do.call(rbind,sannot))[,pos])

rbpSeq <- (annot2 %in% id)

write.fasta(allSeq[!rbpSeq], annot[!rbpSeq], file.out=outFile1, open = "w", nbchar=60)

