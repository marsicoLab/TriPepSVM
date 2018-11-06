suppressPackageStartupMessages(require(seqinr))

options(echo=F) # if you want see commands in output file
args <- commandArgs(trailingOnly = TRUE) # count dont_use_bad_overy

seqFile <- args[1]
outFile1 <- args[2]

allSeq <- read.fasta(file=seqFile,as.string=T,seqtype="AA",seqonly = T)  
annot <- read.fasta(file=seqFile,as.string=T,seqtype="AA",seqonly = F)
annot <- getName(annot)

removeBadLength <- (nchar(allSeq)<50) | (nchar(allSeq)>6000)

write.fasta(allSeq[!removeBadLength], annot[!removeBadLength], file.out=outFile1, open = "w", nbchar=60)


